--莱茵生命·医疗干员-赫默
function c79029028.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029028.splimit)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,79029028)
	e3:SetTarget(c79029028.retg)
	e3:SetOperation(c79029028.reop)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,09029028)
	e4:SetCost(c79029028.tocost)
	e4:SetTarget(c79029028.totg)
	e4:SetOperation(c79029028.toop)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,19029028)
	e5:SetTarget(c79029028.thtg)
	e5:SetOperation(c79029028.thop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c79029028.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029028.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1099)>0 end 
	local rec=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1099)*300
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c79029028.reop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("我会治好你的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029028,1)) 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c79029028.tocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029028.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029029,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029028.toop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029029,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,79029029)
	Debug.Message("去吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029028,2)) 
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029028.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x1907) 
end
function c79029028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029028.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029028.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029028.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("明白，我会做好支援工作。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029028,3)) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	if c:IsCanAddCounter(0x1099,2) and Duel.SelectYesNo(tp,aux.Stringid(79029028,0)) then 
	Debug.Message("集中精力。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029028,4)) 
	c:AddCounter(0x1099,2)
	end
end





