local m=31422002
local cm=_G["c"..m]
cm.name="万感创世者"
if not pcall(function() require("expansions/script/c31422000") end) then require("expansions/script/c31422000") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(aux.DualNormalCondition)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DUAL_STATUS)
	e3:SetCondition(cm.con)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m)
	e4:SetCondition(aux.IsDualState)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.con(e)
	return e:GetHandler():GetEquipCount()~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Seine_wangan.get_emerge_group(e:GetHandler(),e,tp,aux.FALSE)
		return #g>0
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Seine_wangan.get_emerge_group(e:GetHandler(),e,tp,aux.TRUE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	local op=Seine_wangan.emerge_check_op(tc,e,tp)
	if op==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if op==2 then
		Duel.SSet(tp,tc)
	end
end