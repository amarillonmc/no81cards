--罗德岛·辅助干员-波登可
function c79029238.initial_effect(c)
	--pendulum summon
	aux.AddFusionProcFunRep2(c,c79029238.ffilter,2,2,true)
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029238.splimit1)
	c:RegisterEffect(e2)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa900))
	e1:SetValue(c79029238.auval)	
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,79029238)
	e2:SetCondition(c79029238.tocon)
	e2:SetTarget(c79029238.totg)
	e2:SetOperation(c79029238.toop)
	c:RegisterEffect(e2)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c79029238.efcon)
	e4:SetOperation(c79029238.efop)
	c:RegisterEffect(e4)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90036274,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c79029238.pencon)
	e3:SetTarget(c79029238.pentg)
	e3:SetOperation(c79029238.penop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c79029238.pencon1)
	c:RegisterEffect(e4)
end
function c79029238.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029238.ffilter(c)
	return c:IsFusionSetCard(0xa900) and c:IsFusionType(TYPE_PENDULUM)
end
function c79029238.aufil(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029238.auval(e,c,Counter)  
	local g=Duel.GetMatchingGroup(c79029238.aufil,tp,LOCATION_EXTRA,0,nil)
	return g:GetCount()*400
end
function c79029238.tocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029238.thfil1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xb90d)
end
function c79029238.thfil2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900)
end
function c79029238.totg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029238.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c79029238.thfil2,tp,LOCATION_DECK,0,1,nil) end
	local g1=Duel.SelectMatchingCard(tp,c79029238.thfil1,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c79029238.thfil2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,tp,LOCATION_DECK)
end
function c79029238.toop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:Filter(Card.IsType,nil,TYPE_MONSTER):GetFirst()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c79029238.splimit2)
	e1:SetLabelObject(tc)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	e2:SetOperation(c79029238.resop)
	tc:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c79029238.splimit)
	Duel.RegisterEffect(e3,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e3)
	e2:SetOperation(c79029238.resop)
	tc:RegisterEffect(e2)
	--spsummon condition
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetDescription(aux.Stringid(79029238,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetValue(aux.ritlimit)
	tc:RegisterEffect(e0)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e0)
	e2:SetOperation(c79029238.resop)
	tc:RegisterEffect(e2)
	--
	Debug.Message("一定要照顾好自己啊，各位！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029238,1))
end
function c79029238.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL
end  
function c79029238.splimit2(e,c,tp,sumtp,sumpos)
	return c~=e:GetLabelObject() 
end  
function c79029238.resop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) then return end
	e:GetLabelObject():Reset()
	e:Reset()
end
function c79029238.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return (ec:IsSummonType(SUMMON_TYPE_RITUAL))
end
function c79029238.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029238)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029238,5))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e2:SetTarget(c79029238.postg)
	e2:SetOperation(c79029238.posop)
	rc:RegisterEffect(e2)
	Debug.Message("这种杂草我可见过好多了啊。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029238,2))
end
function c79029238.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.SetTargetCard(g)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(g:GetAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c79029238.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Debug.Message("小心花粉过敏哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029238,4))
end
function c79029238.pencon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return (ec:IsSummonType(SUMMON_TYPE_RITUAL))
end
function c79029238.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c79029238.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029238.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("让我来掩护大家！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029238,3))
	end
end



