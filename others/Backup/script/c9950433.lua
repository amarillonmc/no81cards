--fate·女神同盟
function c9950433.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,9950433)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9950433.spcon)
	e2:SetOperation(c9950433.spop)
	c:RegisterEffect(e2)
 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950433,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950433)
	e1:SetTarget(c9950433.tg)
	e1:SetOperation(c9950433.op)
	c:RegisterEffect(e1)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950433.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950433.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950433,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950433,1))
end
function c9950433.rfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(3000) and c:IsReleasable()
end
function c9950433.mzfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(3000) and c:IsReleasable() and c:GetSequence()<5
end
function c9950433.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct>2 then return false end
	if ct>0 and not Duel.IsExistingMatchingCard(c9950433.mzfilter,tp,LOCATION_MZONE,0,ct,nil) then return false end
	return Duel.IsExistingMatchingCard(c9950433.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c9950433.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct<0 then ct=0 end
	local g=Group.CreateGroup()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,c9950433.mzfilter,tp,LOCATION_MZONE,0,ct,ct,nil)
		g:Merge(sg)
	end
	if ct<2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,c9950433.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2-ct,2-ct,g:GetFirst())
		g:Merge(sg)
	end
	Duel.Release(g,REASON_COST)
end
function c9950433.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		return h<3 and Duel.IsPlayerCanDraw(tp,3-h)
	end
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3-h)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3-h)
end
function c9950433.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if h>=3 then return end
	Duel.Draw(p,3-h,REASON_EFFECT)
end