--涌泉之上
function c43990977.initial_effect(c)
	aux.AddCodeList(c,43990987)
	aux.AddMaterialCodeList(c,43990984)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,43990984),aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--spsummon rulr
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990977,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,43990977+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c43990977.sprcon)
	e0:SetTarget(c43990977.sprtg)
	e0:SetOperation(c43990977.sprop)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990977,1))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,43990977)
	e1:SetTarget(c43990977.settg)
	e1:SetOperation(c43990977.setop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--avoid battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA))
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c43990977.matfilter(c)
	return c:IsLevelAbove(1) and c:IsFaceupEx() and c:IsAbleToDeckOrExtraAsCost()
end
function c43990977.gcheck(mg,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0 and mg:IsExists(Card.IsCode,1,nil,43990984) and mg:GetSum(Card.GetLevel)==12
end
function c43990977.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local g=Duel.GetMatchingGroup(c43990977.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:CheckSubGroup(c43990977.gcheck,3,3,tp,c)
end
function c43990977.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c43990977.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c43990977.gcheck,true,3,3,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c43990977.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c43990977.setfilter(c)
	return aux.IsCodeListed(c,43990987) and c:IsFaceupEx() and c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c43990977.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990977.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c43990977.setop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>=2 then ft=2 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c43990977.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		Duel.SSet(tp,sg)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(43990977,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
