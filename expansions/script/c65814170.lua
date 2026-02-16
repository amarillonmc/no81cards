--脑虫 达克斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter1,2,true)
	aux.AddContactFusionProcedure(c,s.ffilter2,LOCATION_HAND+LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST):SetCountLimit(1,id)
	c:SetUniqueOnField(1,0,id)
	aux.AddCodeList(c,id)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.postg1)
	e2:SetOperation(s.posop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.postg2)
	e3:SetOperation(s.posop2)
	c:RegisterEffect(e3)
	--flip
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(s.postg)
	e4:SetOperation(s.posop)
	c:RegisterEffect(e4)
end

function s.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x9a31) and c:IsFusionType(TYPE_MONSTER)
end
function s.ffilter2(c,fc,sub,mg,sg)
	return c:IsSetCard(0x9a31) and c:IsType(TYPE_MONSTER)
end

function s.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsSetCard(0x9a31)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.postg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:CheckUniqueOnField(tp) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() and c:CheckUniqueOnField(tp) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	end
end 


function s.posfilter(c)
	return c:IsFaceup()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(2000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(2000)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end