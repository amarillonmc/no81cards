--动物朋友 乔氏猫
function c33740055.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(33740055,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(33740055)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c33740055.spcon)
	e1:SetTarget(c33740055.sptg)
	e1:SetOperation(c33740055.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(33740055,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33740055.atktg)
	e2:SetOperation(c33740055.atkop)
	c:RegisterEffect(e2)
	if not c33740055.global_check then
		c33740055.global_check=true
		c33740055.trigger_license=true
		--reduction/block
		local _MoveSequence=Duel.MoveSequence
		Duel.MoveSequence=function(...)
			c33740055.trigger_license=false
			return _MoveSequence(...)
		end
		--oxidation/trigger
		local _ConfirmDecktop=Duel.ConfirmDecktop
		Duel.ConfirmDecktop=function(tp,ct)
			local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
			if c33740055.trigger_license and te and te:GetHandler():IsSetCard(0x442) then
				local ge0=Effect.GlobalEffect()
				ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge0:SetCode(EVENT_ADJUST)
				ge0:SetLabel(tp,ct)
				ge0:SetOperation(c33740055.trigger)
				Duel.RegisterEffect(ge0,tp)
			end
			c33740055.trigger_license=true
			return _ConfirmDecktop(tp,ct)
		end
	end
end
function c33740055.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c33740055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33740055.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	--if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
end
function c33740055.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
end
function c33740055.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g>0 and aux.dncheck(g) then
		local lv=g:Filter(Card.IsSetCard,nil,0x442):GetSum(Card.GetLevel)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c33740055.trigger(e,tp,eg,ep,ev,re,r,rp)
	local p,ct=e:GetLabel()
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>=ct then
		local g=Duel.GetDecktopGroup(p,ct)
		Duel.RaiseEvent(g,33740055,e,0,tp,tp,0)
	end
	e:Reset()
end
