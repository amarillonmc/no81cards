--平成三杰·盖亚SV
function c9981435.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9bd1),10,3,c9981435.ovfilter,aux.Stringid(9981435,0),3,c9981435.xyzop)
	c:EnableReviveLimit()
--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetValue(c9981435.efilter)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
 --avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c9981435.damval1)
	c:RegisterEffect(e3)
   --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981435.atkval)
	c:RegisterEffect(e1)
 --material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981435,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981435.macon)
	e1:SetTarget(c9981435.matg)
	e1:SetOperation(c9981435.maop)
	c:RegisterEffect(e1)
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c9981435.disop)
--avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981435.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981435.sumsuc(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981435,0))
end
function c9981435.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c9981435.ovfilter(c)
	return c:IsFaceup() and c:IsCode(9981434,9981436)
end
function c9981435.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981435.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9981435.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9981435.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9981435.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c9981435.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c9981435.macon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end
function c9981435.mafilter(c,tp)
	return (c:IsControler(tp) or c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsAbleToChangeControler()) and not c:IsType(TYPE_TOKEN)
end
function c9981435.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c and c9981435.mafilter(chkc,tp) end
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(c9981435.mafilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9981435.mafilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end
function c9981435.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED)
	if tc:IsRelateToEffect(e) then
	   g:AddCard(tc)
	end
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
	   local sg,sg2=Group.CreateGroup(),Group.CreateGroup()
	   for tc in aux.Next(g) do
		   if not tc:IsImmuneToEffect(e) then
			  local og=tc:GetOverlayGroup()
			  sg2:Merge(og)
			  sg:AddCard(tc)
		   end
	   end
	   if sg2:GetCount()>0 then Duel.SendtoGrave(sg2,REASON_RULE) end
	   if sg:GetCount()>0 then Duel.Overlay(c,sg) end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981435,0))
end
function c9981435.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if ep~=tp and g:GetCount()>0 and g:IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode()) then
	   Duel.NegateEffect(ev)
	end
end