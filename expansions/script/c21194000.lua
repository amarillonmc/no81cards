--超加速枪管上膛
function c21194000.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(21194000)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0x10,0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c21194000.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21194000)
	e3:SetTarget(c21194000.tg)
	e3:SetOperation(c21194000.op)
	c:RegisterEffect(e3)	
	if not c21194000_TRIGGER then
		c21194000_TRIGGER=true
		c21194000_TRIGGER_HACK = Card["RegisterEffect"]
		Card["RegisterEffect"] = 
			function(card,effect,...)
				if card:IsHasEffect(21194000)
					and card:IsSetCard(0x102)
					and card:IsType(TYPE_MONSTER)
					and effect:GetCode()==EVENT_PHASE+PHASE_END
					--and effect:GetRange()==0x10
					and card:IsReason(REASON_BATTLE+REASON_EFFECT) 
					and card:IsReason(REASON_DESTROY) 
					and card:IsPreviousLocation(LOCATION_ONFIELD) then	
					local pro = effect:GetProperty() or 0
					local con = effect:GetCondition()
					local con2 = 
						function(e,tp,eg,ep,ev,re,r,rp)
						return con(e,tp,eg,ep,ev,re,r,rp)
							and e:GetHandler():IsLocation(0x10)
						end
					local e1=effect:Clone(card)
					e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
					e1:SetCode(EVENT_CUSTOM+21194000+1)
					e1:SetProperty(pro+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
					e1:SetCondition(con2)
					c21194000_TRIGGER_HACK(card,e1,true)
					local e2=Effect.CreateEffect(card)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_ADJUST)
					e2:SetRange(LOCATION_GRAVE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCountLimit(1)
					e2:SetOperation(c21194000.op0)
					e2:SetReset(RESET_PHASE+PHASE_END)
					return c21194000_TRIGGER_HACK(card,e2,...)
				else
					return c21194000_TRIGGER_HACK(card,effect,...)
				end
			end
	end	
end
function c21194000.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+21194000+1,re,r,rp,ep,ev)
	e:Reset()
end
function c21194000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON))
end
function c21194000.q(c)
	return c:IsType(1) and c:IsSetCard(0x102) and c:IsAbleToHand()
end
function c21194000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21194000.q,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
end
function c21194000.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21194000.q,tp,1,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
	Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(2) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(21194000,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x102))
		Duel.RegisterEffect(e1,tp)
		end
	end
end