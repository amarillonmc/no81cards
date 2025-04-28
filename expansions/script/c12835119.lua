--侍之魂 樱杀
local m=12835119
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Update ATTACK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.indescon)
	e1:SetCost(cm.indescost)
	e1:SetTarget(cm.indestg)
	e1:SetOperation(cm.indesop)
	c:RegisterEffect(e1)
	--imn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.imncon)
	e2:SetOperation(cm.imnop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.effect_count=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetCondition(cm.checkcon)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHANGE_POS)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge5:SetCode(EVENT_CHAINING)
		ge5:SetOperation(cm.regop)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_CHAIN_NEGATED)
		ge6:SetOperation(cm.regop2)
		Duel.RegisterEffect(ge6,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	cm.effect_count=cm.effect_count+1
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	cm.effect_count=cm.effect_count-1
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
end
function cm.indescon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	e:SetLabelObject(a)
	return a and d and a:IsFaceup() and a:IsSetCard(0x3a70)
end
function cm.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=e:GetLabelObject()
	if a:IsRelateToBattle() and a:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cm.effect_count*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		a:RegisterEffect(e1)
	end
end
function cm.imnfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition() and c:IsCode(0x3a70) 
end
function cm.imncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPublic() and rp==1-tp and Duel.IsExistingMatchingCard(cm.imnfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,m)==0
end
function cm.imnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		local tc=Duel.SelectMatchingCard(tp,cm.imnfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if tc then
			Duel.HintSelection(tc)
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(aux.indoval)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_REMOVE)
			e2:SetTargetRange(1,1)
			e2:SetLabelObject(tc:GetFirst())
			e2:SetTarget(cm.efilter)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetOperation(function(ce,ctp)
			Duel.ResetFlagEffect(ctp,m) 
			e1:Reset()
		end)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.efilter(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and c:IsControler(tp) and c==e:GetLabelObject() and re and r&REASON_EFFECT>0 and rp==1-tp
end