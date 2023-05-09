package com.example.campusin.domain.comment;

import com.example.campusin.domain.user.User;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import com.querydsl.core.annotations.QueryProjection;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CommentsOnPostResponse extends CommentResponse{

    private List<CommentsOnPostResponse> children = new ArrayList<>();

    @QueryProjection
    public CommentsOnPostResponse(String userId, Long parentId, Long commentId, String name, String content) {
        super(userId, parentId, commentId, name, content);
        this.children = children;
    }

    public void setChildren(List<CommentsOnPostResponse> children){
        this.children = children;
    }

    public static CommentsOnPostResponse of(Comment comment) {
        User user = comment.getUser();
        Comment parent = comment.getParent();
        String name = user.getUsername();
        String content = comment.getIsDelete() || user == null ? "삭제된 댓글입니다." : comment.getContent();

        return new CommentsOnPostResponse(
                user == null ? null : user.getUserId(),
                parent == null ? null : parent.getId(),
                comment.getId(),
                name,
                content
        );
    }

    public int getChildrenSize() {
        return children.size();
    }
}
