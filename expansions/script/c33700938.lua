--动物朋友 杰克灯鬼火
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700938
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	local e1=rsef.I(c,{m,0},{1,m},"tg,rec",nil,LOCATION_MZONE,nil,nil,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return false end
		local g=Duel.GetDecktopGroup(tp,10)
		return g:FilterCount(Card.IsAbleToGrave,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetDecktopGroup(tp,10)
	Duel.ConfirmDecktop(tp,10)
	local codect=rg:GetClassCount(Card.GetCode)
	if #rg>0 and codect==#rg and rg:FilterCount(Card.IsAbleToGrave,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=rg:FilterSelect(tp,Card.IsAbleToGrave,1,5,nil)
		if #tg>0 then 
			local rct=Duel.SendtoGrave(tg,REASON_EFFECT)
			Duel.Recover(tp,rct*800,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local e1=rsef.FV({c,tp},EFFECT_REVERSE_DECK,nil,nil,{1,0},nil,nil,{rsreset.pend+RESET_SELF_TURN,2},"ptg")
	local e2=rsef.FV({c,tp},EFFECT_CHANGE_DAMAGE,0,nil,{1,0},nil,nil,{rsreset.pend+RESET_SELF_TURN,2},"ptg")   
	local e3=rsef.FV({c,tp},EFFECT_NO_EFFECT_DAMAGE,0,nil,{1,0},nil,nil,{rsreset.pend+RESET_SELF_TURN,2},"ptg")   
end
