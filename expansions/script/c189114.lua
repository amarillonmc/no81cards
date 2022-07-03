local m=189114
local cm=_G["c"..m]
cm.name="恒夜骑士-刺影之塞维尔"
if not pcall(function() require("expansions/script/c189113") end) then require("script/c189113") end
function cm.initial_effect(c)
	ven.EnableSpiritReturn(c,function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(c)return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then Duel.Summon(tp,tc,true,nil) else Duel.MSet(tp,tc,true,nil) end
	end
	,CATEGORY_SUMMON,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if dg:GetCount()>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
