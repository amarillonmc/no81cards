local m=82206084
local cm=_G["c"..m]
cm.name="暗之鏖战"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--atk&def
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x29c))  
	e2:SetValue(cm.val)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3) 
	--cannot be target  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetTargetRange(LOCATION_MZONE,0)  
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x29c))  
	e4:SetValue(aux.tgoval)  
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e5:SetTargetRange(0,1)  
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.actcon)  
	e5:SetValue(1)   
	c:RegisterEffect(e5)  
	--draw  
	local e6=Effect.CreateEffect(c)  
	e6:SetDescription(aux.Stringid(m,0))  
	e6:SetCategory(CATEGORY_DRAW)  
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e6:SetCode(EVENT_BATTLE_DESTROYING)  
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)  
	e6:SetRange(LOCATION_SZONE)  
	e6:SetCountLimit(1,82216084)  
	e6:SetCondition(cm.drcon)  
	e6:SetTarget(cm.drtg)  
	e6:SetOperation(cm.drop)  
	c:RegisterEffect(e6)  
end
function cm.val(e,c)  
	return Duel.GetMatchingGroupCount(nil,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29c)
end  
function cm.actcon(e)  
	local ph=Duel.GetCurrentPhase()  
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)	
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local rc=eg:GetFirst()  
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)  
		and rc:IsFaceup() and rc:IsSetCard(0x29c) and rc:IsControler(tp)   
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  