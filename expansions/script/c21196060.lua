--皇庭学院的棋师
local m=21196060
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(cm.fscondition())
	e0:SetOperation(cm.fsoperation())
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.mat1(c,mg)
	return c:IsFusionSetCard(0x5919) and mg:IsExists(function(card) return card:IsFusionSetCard(0x5919) end,1,c)
end
function cm.mat2(c,mg)
	return c:IsFusionSetCard(0x5919) and c:IsFusionType(TYPE_SYNCHRO) and mg:IsExists(function(card) return card:IsFusionType(TYPE_EFFECT) end,1,c)
end
function cm.check(g,tp,c)
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,c) then
		return false
	end
	if Auxiliary.FGoalCheckAdditional and not Auxiliary.FGoalCheckAdditional(tp,g,c) then
		return false
	end
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and (g:IsExists(cm.mat1,1,nil,g) or g:IsExists(cm.mat2,1,nil,g))
end
function cm.fscondition()
	return  function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local c,tp=e:GetHandler(),e:GetHandlerPlayer()
			local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,c)
			if Duel.GetLocationCountFromEx(tp,tp,mg,c)<=0 then return end
			return mg:CheckSubGroup(cm.check,1,nil,tp,c)
		end
end
function cm.fsoperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local c=e:GetHandler()
			local tp=c:GetControler()
			local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,c)
			if not mg:CheckSubGroup(cm.check,1,nil,tp,c) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:SelectSubGroup(tp,cm.check,false,2,2,tp,c)
			Duel.SetFusionMaterial(sg)
		end
end
function cm.val(e,c)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x10+12,0x10+12,nil)
	local a=g:IsExists(Card.IsType,1,nil,TYPE_FUSION) and 1 or 0
	local b=g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and 1 or 0
	local c=g:IsExists(Card.IsType,1,nil,TYPE_XYZ) and 1 or 0
	local d=g:IsExists(Card.IsType,1,nil,TYPE_LINK) and 1 or 0
	return -500*(a+b+c+d)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and in_count[tp] < 8
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	in_count.add(tp,2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(cm.con2_1)
	e2:SetOperation(cm.op2_1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function cm.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,800,REASON_EFFECT)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function cm.q(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.q,tp,4,4,1,nil) end
	Duel.Hint(3,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.q,tp,4,4,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end