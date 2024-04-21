--器灵·电闪雷鸣锤
function c60153305.initial_effect(c)

	--1效果
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60153305,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c60153305.e1con)
	e1:SetOperation(c60153305.e1pop)
	c:RegisterEffect(e1)
	
	--2效果
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60153305,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c60153305.e2op)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60153305,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c60153305.e4con)
	e4:SetOperation(c60153305.e4op)
	c:RegisterEffect(e4)
	
	--3效果
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60153305,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c60153305.e3tg)
	e3:SetOperation(c60153305.e3op)
	c:RegisterEffect(e3)
end

--1效果

function c60153305.e1conf(c)
	return c:IsFaceup() and c:IsCode(60153218) and not c:IsDisabled()
end
function c60153305.e1con(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	if not Duel.IsExistingMatchingCard(c60153305.e1conf,tp,LOCATION_FZONE,0,1,nil) then
		return Duel.CheckLPCost(tp,1000)
	else
		return true
	end
end
function c60153305.e1pop(e,tp,eg,ep,ev,re,r,rp,c)
	if not Duel.IsExistingMatchingCard(c60153305.e1conf,tp,LOCATION_FZONE,0,1,nil) then
		Duel.PayLPCost(tp,1000)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c60153305.lim)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetReset(RESET_EVENT+0xff0000)
	e7:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e7)
	c:RegisterFlagEffect(0,RESET_EVENT+0xff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60153305,0))
end
function c60153305.lim(e,c,st)
	return st==SUMMON_TYPE_FUSION
end

--2效果

function c60153305.e2op(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(60153305,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c60153305.e4con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(60153305)~=0
end
function c60153305.e4op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60153305)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end

--3效果

function c60153305.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c60153305.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 and Duel.IsExistingMatchingCard(c60153305.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c60153305.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil,tp,POS_FACEDOWN)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg2=g2:Select(tp,1,1,nil)
		dg1:Merge(dg2)
		if dg1:GetCount()==2 then
			Duel.HintSelection(dg1)
			if Duel.Remove(dg1,POS_FACEDOWN,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				local g=Duel.GetMatchingGroup(c60153305.rmfilter,tp,0,LOCATION_EXTRA,nil)
				if g:GetCount()==0 then return end
				local tc=g:RandomSelect(tp,1):GetFirst()
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end