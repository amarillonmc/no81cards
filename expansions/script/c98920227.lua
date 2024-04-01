--吸血鬼吟游诗人
function c98920227.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920227.matfilter,1,1)
	c:EnableReviveLimit()
	--force mzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e2:SetTarget(c98920227.target)
	e2:SetValue(c98920227.frcval)
	c:RegisterEffect(e2)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98920227,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98920227.xyzcon)
	e0:SetOperation(c98920227.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_MZONE)
	e33:SetTargetRange(LOCATION_EXTRA,0)
	e33:SetTarget(c98920227.eftg1)
	e33:SetLabelObject(e0)
	c:RegisterEffect(e33)
	--gain LP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920227,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,98920227)
	e3:SetCondition(c98920227.atkcon)
	e3:SetCost(c98920227.costs)
	e3:SetTarget(c98920227.targets)
	e3:SetOperation(c98920227.operations)
	c:RegisterEffect(e3)
end
function c98920227.eftg1(e,c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_ZOMBIE)
end
function c98920227.matfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(5)
end
function c98920227.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c98920227.filter1(c)
	return c:GetFlagEffect(98920277)~=0
end
function c98920227.target(e,c)
	return c:GetFlagEffect(98920227)~=0
end
function c98920227.cfilter(c)
	return c:IsFaceup() and c:IsCode(98920227) and c:IsType(TYPE_LINK)
end
function c98920227.frcval(e,c,fp,rp,r)
	local zone=0
	local g=Duel.GetMatchingGroup(c98920227.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c98920227.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c98920227.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c98920227.mfilter(c,xyzc)
	return c:IsCanBeXyzMaterial(xyzc) and c:IsFaceup() and (c:IsLevel(xyzc:GetRank()) or (xyzc:IsCode(32302078,73082255) and c:IsLevelAbove(0) and c:GetOwner()~=xyzc:GetOwner()))
end
function c98920227.xyzcon(e,c,smat)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and (not min or min<=2 and max>=2)
		and Duel.IsExistingMatchingCard(c98920227.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,c)
		and Duel.GetFlagEffect(tp,98920227)==0
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920227.xyzop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local xyzg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=nil
		if og then
			mg=og:Filter(c98920227.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c98920227.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mtg=mg:Select(tp,2,2,nil)
		xyzg:Merge(mtg)
	end
	Duel.RegisterFlagEffect(c:GetControler(),98920227,RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(98920227,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-c:GetControler(),aux.Stringid(98920227,0))
	c:SetMaterial(xyzg)
	Duel.Overlay(c,xyzg)
end
function c98920227.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and aux.dscon()
end
function c98920227.costs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920227.targets(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c98920227.operations(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-500)
	Duel.Recover(tp,500,REASON_EFFECT)
end