local m=189118
local cm=_G["c"..m]
cm.name="恒夜骑士-昏暗之奎狄"
if not pcall(function() require("expansions/script/c189113") end) then require("script/c189113") end
function cm.initial_effect(c)
	ven.EnableSpiritReturn(c,function(e,tp,eg,ep,ev,re,r,rp)
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if #hg+#fg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
		local g
		if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==0) then
			g=hg:RandomSelect(tp,1)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		end
		if g:GetCount()~=0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	,CATEGORY_DESTROY,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsType(TYPE_SPIRIT) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil)
			or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
			Duel.Summon(tp,tc,true,nil)
		else Duel.MSet(tp,tc,true,nil) end
	end
end
