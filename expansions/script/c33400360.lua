--第十领域-血战之域
function c33400360.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,33400360)
	e3:SetCost(c33400360.drcost)
	e3:SetTarget(c33400360.drtg)
	e3:SetOperation(c33400360.drop)
	c:RegisterEffect(e3)
	--ChainAttack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,33400360+10000)
	e4:SetCondition(c33400360.cacon)
	e4:SetOperation(c33400360.caop)
	c:RegisterEffect(e4)
	  --inactivatable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetValue(c33400360.effectfilter)
	c:RegisterEffect(e6)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c33400360.effectfilter)
	c:RegisterEffect(e5)
end
function c33400360.costfilter(c)
	return c:IsSetCard(0x5341) and c:IsReleasableByEffect()
end
function c33400360.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400360.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c33400360.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST) 
end
function c33400360.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33400360.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c33400360.cacon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
	local c=e:GetHandler()
	return  des:IsType(TYPE_MONSTER) and rc:IsRelateToBattle() and rc:IsType(TYPE_RITUAL) 
	and rc:IsType(TYPE_MONSTER)  and des:GetControler()~=rc:GetControler() and rc:GetControler()==Duel.GetTurnPlayer()  and Duel.GetTurnPlayer()==tp
end
function c33400360.caop(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
	if rc then
	 Duel.ChainAttack() 
	end
end
function c33400360.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x5341) and te:GetHandler():IsType(TYPE_RITUAL) and 
	te:GetHandler():IsType(TYPE_SPELL)  and (bit.band(loc,LOCATION_ONFIELD)~=0 or bit.band(loc,LOCATION_HAND)~=0)
end
