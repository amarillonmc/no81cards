--歧路诗篇－先贤剧场－
function c91300083.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c91300083.activate)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91300083,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+91300083)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c91300083.activate)
	c:RegisterEffect(e1)
	--
	if not c91300083.global_check then
		c91300083.global_check=true
		local _TossDice=Duel.TossDice
		function Duel.TossDice(...)
			Duel.RegisterFlagEffect(0,91300083,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+91300083,nil,0,0,0,0)
			return _TossDice(...)
		end
		local _TossCoin=Duel.TossCoin
		function Duel.TossCoin(...)
			Duel.RegisterFlagEffect(0,91300084,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+91300083,nil,0,0,0,0)
			return _TossCoin(...)
		end
		local _RockPaperScissors=Duel.RockPaperScissors
		function Duel.RockPaperScissors(...)
			Duel.RegisterFlagEffect(0,91300085,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+91300083,nil,0,0,0,0)
			return _RockPaperScissors(...)
		end
	end
end
function c91300083.thfilter(c)
	if not c:IsAbleToHand() then return false end
	local b1=c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) and Duel.GetFlagEffect(0,91300083)==0
	local b2=c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) and Duel.GetFlagEffect(0,91300084)==0
	local b3=c:IsCode(9300420,10173087,33701339,91300067,91300073,91300079) and Duel.GetFlagEffect(0,91300085)==0
	return b1 or b2 or b3
end
function c91300083.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+91300083)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c91300083.thop)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c91300083.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c91300083.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	e:Reset()
end
