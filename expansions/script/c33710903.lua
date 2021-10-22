--天之理
function c33710903.initial_effect(c)
	--re
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33710903,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33710903.target)
	e1:SetOperation(c33710903.operation)
	c:RegisterEffect(e1) 
	if not c33710903.global_check then
		c33710903.global_check=true
		Count_Time_For_This_Effect={0,0,0,0}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33710903.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(c33710903.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c33710903.checkop(e,tp,eg,ep,ev,re,r,rp)
	Count_Time_For_This_Effect[re:GetHandlerPlayer()+3]=Count_Time_For_This_Effect[re:GetHandlerPlayer()+3]+1
end
function c33710903.checkop2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(0)
	Count_Time_For_This_Effect[1]=Count_Time_For_This_Effect[3]
	Count_Time_For_This_Effect[2]=Count_Time_For_This_Effect[4]
	Count_Time_For_This_Effect[3]=0
	Count_Time_For_This_Effect[4]=0
end
function c33710903.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c33710903.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetTargetRange(1,0)
	e0:SetValue(c33710903.actlimit)
	Duel.RegisterEffect(e0,tp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local c=e:GetHandler()
	if g:GetCount()>0 then
			g:GetFirst():ReverseInDeck()
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(aux.Stringid(33710903,1))
			e1:SetCategory(CATEGORY_DAMAGE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_TO_HAND)
			e1:SetTarget(c33710903.sptg)
			e1:SetOperation(c33710903.spop)
			e1:SetReset(RESET_EVENT+0x1de0000)
			tc:RegisterEffect(e1)
	end
end
function c33710903.actlimit(e,te,tp)
	local g=Duel.GetDecktopGroup(tp,1)
	if not g then return false end
	return Duel.GetTurnPlayer()~=tp
		and g:GetFirst():IsFaceup()
end
function c33710903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,Count_Time_For_This_Effect[2-tp]*500)
end
function c33710903.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(1-tp,Count_Time_For_This_Effect[2-tp]*500,REASON_EFFECT)
	if c:IsRelateToEffect(e) then
		Duel.ShuffleHand(tp)
	end
end