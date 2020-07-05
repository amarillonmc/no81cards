--UESTC·思月
local m=10400025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x680),2,99)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10400025.regcon)
	e2:SetOperation(c10400025.regop)
	c:RegisterEffect(e2)
end
function c10400025.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c10400025.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c10400025.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterialCount()>=2 then
		--water immune
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetValue(1)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e7)
	end
	if c:GetMaterialCount()>=3 then
		--light
		--attack all
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ATTACK_ALL)
		e4:SetValue(1)
		c:RegisterEffect(e4)
		--pierce
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_PIERCE)
		c:RegisterEffect(e5)
	end
	if c:GetMaterialCount()>=4 then
		--dark
		--pos
		local e8=Effect.CreateEffect(c)
		e8:SetDescription(aux.Stringid(10400025,3))
		e8:SetCategory(CATEGORY_POSITION)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e8:SetCode(EVENT_SPSUMMON_SUCCESS)
		e8:SetRange(LOCATION_MZONE)
		e8:SetCountLimit(1)
		e8:SetTarget(c10400025.target2)
		e8:SetOperation(c10400025.operation2)
		c:RegisterEffect(e8)
		local e9=e8:Clone()
		e9:SetCode(EVENT_SUMMON_SUCCESS)
		c:RegisterEffect(e9)   
	end
	if c:GetMaterialCount()>=5 then
		--earth grave
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(10400025,2))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTarget(c10400025.target)
		e3:SetOperation(c10400025.activate)
		c:RegisterEffect(e3)
	end
	if c:GetMaterialCount()>=6 then
		 --wind special summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(10400025,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c10400025.sptg2)
		e2:SetOperation(c10400025.spop2)
		c:RegisterEffect(e2)		
		--fire LP
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(10400025,0))
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c10400025.damtg)
		e1:SetOperation(c10400025.damop)
		c:RegisterEffect(e1)
	end
end


function c10400025.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMaterialCount()>0 and c:IsSummonType(SUMMON_TYPE_LINK)
end

--water
function c10400025.value(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetMaterial()
	if c10400025.op1 and c10400025.con then return 1
	end
end

--fire
function c10400025.firecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0
end
function c10400025.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c10400025.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--wind
function c10400025.windcon(e,tp,eg,ep,ev,re,r,rp)
	return c10400025.op3 and c10400025.con 
end
function c10400025.spfilter2(c,e,tp)
	return c:IsSetCard(0x6681) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10400025.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10400025.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10400025.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10400025.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--erath
function c10400025.earthcon(e,tp,eg,ep,ev,re,r,rp)
	return c10400025.op4 and c10400025.con
end
function c10400025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c10400025.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

--light
function c10400025.value2(e,tp,eg,ep,ev,re,r,rp)
	if c10400025.op5 and c10400025.con then return 1 end
end
function c10400025.lightcon(e,tp,eg,ep,ev,re,r,rp)
	return c10400025.op5 and c10400025.con
end

--dark
function c10400025.darkcon(e,tp,eg,ep,ev,re,r,rp)
	return c10400025.op6 and c10400025.con
end
function c10400025.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:GetSummonPlayer()==1-tp and (not e or c:IsRelateToEffect(e))
end
function c10400025.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10400025.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c10400025.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10400025.filter,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end

--opt
function c10400025.cfilter1(e,tp,eg,ep,ev,re,r,rp)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c10400025.cfilter2(e,tp,eg,ep,ev,re,r,rp)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c10400025.cfilter3(e,tp,eg,ep,ev,re,r,rp)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c10400025.cfilter4(e,tp,eg,ep,ev,re,r,rp)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10400025.cfilter5(e,tp,eg,ep,ev,re,r,rp)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c10400025.cfilter6(e,tp,eg,ep,ev,re,r,rp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c10400025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMaterial():IsExists(c10400025.cfilter1,1,nil)
end
function c10400025.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMaterial():IsExists(c10400025.cfilter2,1,nil)
end
function c10400025.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		return c:GetMaterial():IsExists(c10400025.cfilter3,1,nil)
end
function c10400025.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		return c:GetMaterial():IsExists(c10400025.cfilter4,1,nil)
end
function c10400025.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		return c:GetMaterial():IsExists(c10400025.cfilter5,1,nil)
end
function c10400025.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		return c:GetMaterial():IsExists(c10400025.cfilter6,1,nil)
end