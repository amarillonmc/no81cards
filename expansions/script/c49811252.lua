--R.X-剑士 索萨
function c49811252.initial_effect(c)
	c:SetSPSummonOnce(49811252)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c49811252.spcon)
	e1:SetOperation(c49811252.spop)
	c:RegisterEffect(e1)
	--cannot special summon
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e11)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd))
	e2:SetValue(c49811252.efilter)
	c:RegisterEffect(e2)
	--draw or control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c49811252.con)
	e3:SetTarget(c49811252.tg)
	e3:SetOperation(c49811252.op)
	c:RegisterEffect(e3)
end
function c49811252.spcfilter(c)
	return c:IsSetCard(0x100d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c49811252.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811252.spcfilter,tp,LOCATION_HAND,0,1,c)
end
function c49811252.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c49811252.spcfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c49811252.efilter(e,te,c)
	local tc=te:GetOwner()
	return not tc:IsSetCard(0x100d) and tc:IsLocation(LOCATION_ONFIELD)
		and bit.band(te:GetActiveType(),c:GetType())~=0
end
function c49811252.cfilter(c,p)
	return c:IsSetCard(0x100d) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(p)
end
function c49811252.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811252.cfilter,1,nil,1-tp)
end
function c49811252.ctfilter(c)
	return c:IsSetCard(0x100d) and c:IsControlerCanBeChanged()
end
function c49811252.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,49811252)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811252.ctfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,49811352)==0
	if chk==0 then return b1 or b2 end
end
function c49811252.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,49811252)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811252.ctfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,49811352)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(49811252,1),aux.Stringid(49811252,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(49811252,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(49811252,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Debug.Message("现在的我无比强大！")
		Duel.RegisterFlagEffect(tp,49811252,RESET_PHASE+PHASE_END,0,1)
	else
		local g=Duel.GetMatchingGroup(c49811252.ctfilter,tp,0,LOCATION_MZONE,nil)
		local cg=g:GetMinGroup(Card.GetAttack)
		if cg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			cg=cg:Select(tp,1,1,nil)
		end
		Duel.GetControl(cg,tp)
		Debug.Message("老伙计，加入我吧！")
		Duel.RegisterFlagEffect(tp,49811352,RESET_PHASE+PHASE_END,0,1)
	end
end