//
//  NotificationCenter.m
//  FlightSearchRSN
//
//  Created by Sergey Razgulyaev on 10.02.2021.
//

#import "NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import "TicketsViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "TabBarController.h"
#import "CoreDataHelper.h"

@interface NotificationCenter () <UNUserNotificationCenterDelegate>
@end

@implementation NotificationCenter

+ (instancetype)sharedInstance
{
    static NotificationCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NotificationCenter alloc] init];
        
    });
    return instance;
}

- (void)registerService {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Request authorization succeeded!");
        }
    }];
}

- (void)sendNotification:(Notification)notification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notification.date];
    
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notification"
                                                                          content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

Notification NotificationMake(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date, NSURL * _Nullable imageURL) {
    Notification notification;
    notification.title = title;
    notification.body = body;
    notification.date = date;
    notification.imageURL = imageURL;
    
    return notification;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge |UNAuthorizationOptionSound);
    NSLog(@"Notification recieved");
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *descriptionTitle = ((UNMutableNotificationContent *)response.notification.request.content).body;
    
    NSString *departurePlace = [descriptionTitle  substringToIndex:3];
    NSString *arrivalPlace = [descriptionTitle substringWithRange:NSMakeRange(6, 3)];
    NSString *priceInStringFormat = [descriptionTitle substringWithRange:NSMakeRange(14, ([descriptionTitle length] - 19))];
    NSNumber *price = [NSNumber numberWithInt: [priceInStringFormat intValue]];
    
    Ticket * remindedTicketForInit = [[Ticket alloc] initWithDeparturePlace:departurePlace ArrivalPlace:arrivalPlace Price:price];
    
    FavoriteTicket *remindedTicket = [[CoreDataHelper sharedInstance] remindedTicket:remindedTicketForInit];
    
    TicketsViewController *remindedTicketsController = [[TicketsViewController alloc] initWithRemindedTicket: remindedTicket];
    UIViewController *tabBarController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [tabBarController showViewController:remindedTicketsController sender:tabBarController];

    completionHandler();
}

@end
