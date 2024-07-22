--战车道少女·橙黄白毫
dofile("expansions/script/c9910100.lua")
function c9910127.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,CATEGORY_RECOVER+CATEGORY_DRAW,false,c9910127.exchk2,false,c9910127.beftd2,true,nil)
end
function c9910127.exchk2(e,tp)
	return Duel.IsPlayerCanDraw(tp,1)
end
function c9910127.beftd2(e,tp)
	if Duel.Recover(1-tp,1000,REASON_EFFECT)<=0 or Duel.Draw(tp,1,REASON_EFFECT)==0 then return false end
	return true
end
