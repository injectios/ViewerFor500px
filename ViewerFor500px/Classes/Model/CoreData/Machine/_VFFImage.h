// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VFFImage.h instead.

@import CoreData;

extern const struct VFFImageAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *thumbUrl;
	__unsafe_unretained NSString *url;
	__unsafe_unretained NSString *userName;
} VFFImageAttributes;

@interface VFFImageID : NSManagedObjectID {}
@end

@interface _VFFImage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) VFFImageID* objectID;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int32_t identifierValue;
- (int32_t)identifierValue;
- (void)setIdentifierValue:(int32_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* thumbUrl;

//- (BOOL)validateThumbUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userName;

//- (BOOL)validateUserName:(id*)value_ error:(NSError**)error_;

@end

@interface _VFFImage (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int32_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int32_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveThumbUrl;
- (void)setPrimitiveThumbUrl:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (NSString*)primitiveUserName;
- (void)setPrimitiveUserName:(NSString*)value;

@end
