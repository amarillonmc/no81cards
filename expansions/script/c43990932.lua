--自助餐
function c43990932.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3511),aux.TRUE,3,283,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--spsummon
	local se0=Effect.CreateEffect(c)
	se0:SetType(EFFECT_TYPE_FIELD)
	se0:SetCode(EFFECT_SPSUMMON_PROC)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se0:SetRange(LOCATION_EXTRA)
	se0:SetValue(SUMMON_VALUE_SELF)
	se0:SetCondition(c43990932.sprcon)
	se0:SetTarget(c43990932.sprtg)
	se0:SetOperation(c43990932.sprop)
	c:RegisterEffect(se0)
	--win
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	se1:SetCode(EVENT_SPSUMMON_SUCCESS)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	se1:SetOperation(c43990932.winop)
	c:RegisterEffect(se1)
	--base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)--+EFFECT_FLAG_CANNOT_DISABLE
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c43990932.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c43990932.tgop)
	c:RegisterEffect(e4)
	--count
	if not c43990932.global_check then
		c43990932.global_check=true
		c43990932.leave_count=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c43990932.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_LEAVE_GRAVE)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_LEAVE_DECK)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(ge4,0)
	end
end
function c43990932.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetCode()==EVENT_LEAVE_DECK and LOCATION_EXTRA or LOCATION_HAND+LOCATION_REMOVED
	local sg=(e:GetCode()==EVENT_LEAVE_FIELD or e:GetCode()==EVENT_LEAVE_GRAVE) and eg or eg:Filter(Card.IsPreviousLocation,nil,loc)
	c43990932.leave_count=c43990932.leave_count+#sg
end
function c43990932.matfilter(c)
	return c:IsFusionCode(43990944) and c:GetBaseAttack()>10000 and c:IsReleasable(REASON_SPSUMMON) and c:IsCanBeFusionMaterial()
end
function c43990932.gcheck(mg,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0
end
function c43990932.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c43990932.matfilter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(c43990932.gcheck,1,1,tp,c)
end
function c43990932.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c43990932.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c43990932.gcheck,true,1,1,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c43990932.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	Duel.Release(mg,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c43990932.winop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_VALUE_SELF) then return end
	local WIN_REASON_BUFFET = 0x67
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_BUFFET)
end
function c43990932.atkval(e,c)
	return c43990932.leave_count*100
end
function c43990932.tgop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp and Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(rp,Card.IsAbleToGrave,rp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
