(function ($) {
  // Возвращет комментарий по его ID
  function getCommentByID (id) {
    return $(".comment[data-id=" + id + "]");
  }

  // Навешиваем обработчик на форму
  $(".comment form").live ("ajax:success", function (xhr, data) {
    $(this).replaceWith (data);
  });

  // Ссылка на создание комментария
  $(".new-comment-link").live ("click", function (event) {
    event.preventDefault ();

    // Уничтожаем все формы создания комментария и показываем ссылки
    $(".comment form").remove ();

    var link = $(this);

    // Парамeтры хранятся как HTML атрибуты
    var params = {
        commentable_type : link.data ("commentable-type")
      , commentable_id   : link.data ("commentable-id")
    };

    $.get (link.attr ("href"), params).success (function (data) {
      // Ищем ближайший к ссылке комментарий и в нём уже ищем плейсхолдер
      var placeholder = link.closest (".comment")
                            .find (link.data ("placeholder"))
                            .first();

      console.log (link.data ("placeholder"), link, placeholder);

      if (placeholder.length) {
        placeholder.append (data);
      }
      else {
        link.before (data);
      }

      $("#comment_body").focus ();
    });
  });

  // Ссылка на редактирование комментария
  $(".edit-comment-link").live ("click", function (event) {
    event.preventDefault ();

    var link = $(this);

    $.get ($(this).attr ("href")).success (function (data) {
      getCommentByID (link.data( "comment-id" )).replaceWith (data);
    });
  });

  // Ссылка на удаление комментария
  $(".remove-comment-link").live ("ajax:success", function (xhr, data) {
    getCommentByID ($(this).data ("comment-id")).replaceWith (data);
  });
}) (jQuery);