import ballerina/time;

type UserRegistration record {
    string name;
    string email;
    string password;
};

type SuccessResponse record {
    string message;
};

type FailureResponse record {
    string error_message;
};

type UserCredentials record {
    string name;
    string password;
};

type UserLogin record {
    string message;
    string id;
};

type NewForumPost record {
    string title;
    string description;
    string timestamp;
};

type ForumPostInDB record {
    string id;
    string user_id;
    string title;
    string description;
    time:Civil posted_at;
    string likes = "[]";
};

type LikePost record {
    string userId;
};

type NewPostComment record {
    string userId;
    string comment;
    string timestamp;
};

type PostCommentInDB record {
    string id;
    string post_id;
    string user_id;
    string comment;
    time:Civil posted_at;
};
