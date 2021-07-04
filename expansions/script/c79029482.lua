--联合行动-双龙出鞘
function c79029482.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(29065574)
	c:RegisterEffect(e0) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029482)
	e1:SetCondition(c79029482.condition)
	e1:SetTarget(c79029482.target)
	e1:SetOperation(c79029482.activate)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19029482)
	e2:SetCondition(c79029482.xxcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029482.xxtg)
	e2:SetOperation(c79029482.xxop)
	c:RegisterEffect(e2)
end
function c79029482.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c79029482.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(79029482)==0 and c:IsLinkAbove(6) and c:IsSetCard(0xa900)
end
function c79029482.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79029482.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029482.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029482.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79029482.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(79029482)==0 then
	if tc:IsCode(79029359) then 
	Debug.Message("我背负着许多人的愤怒。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029482,3))
	elseif tc:IsCode(79029025) then 
	Debug.Message("没问题。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029482,4))	
	end
			tc:RegisterFlagEffect(79029482,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029482,0))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetCondition(c79029482.actcon)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(c79029482.effcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(0,LOCATION_ONFIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetCondition(c79029482.actcon)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e4:SetCondition(c79029482.damcon)
			e4:SetOperation(c79029482.damop)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end
function c79029482.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c79029482.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c79029482.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and ep~=tp and e:GetOwnerPlayer()==e:GetHandlerPlayer() 
end
function c79029482.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*4)
	if e:GetHandler():IsCode(79029359) then 
	Debug.Message("“我该用什么回应你的不义？”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029482,1))
	elseif e:GetHandler():IsCode(79029025) then 
	Debug.Message("闪！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029482,2))	
	end
end
function c79029482.xxcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c79029482.xxfil(c)
	return c:GetBaseAttack()>0 and c:IsSetCard(0xa900) and c:IsLinkAbove(6)
end
function c79029482.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79029482.xxfil,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:Filter(c79029482.xxfil,nil):GetSum(Card.GetBaseAttack)/2)
end
function c79029482.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c79029482.xxfil,nil)
	local x=g:GetSum(Card.GetBaseAttack)/2 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,x,REASON_EFFECT)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	if tc:IsCode(79029359) then 
	Debug.Message("要战斗到哪一天，蔓延在大地上的怒火才会平息呢......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029482,5))
	elseif tc:IsCode(79029025) then 
	Debug.Message("罪恶绝不能被容忍，不管用什么办法我都要阻止你们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029482,6))	
	end
	tc=g:GetNext()
	end
end







