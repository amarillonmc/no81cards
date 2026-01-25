--元素百科全书通晓者
--1200200
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,id)
	e0:SetCondition(s.linkcon)
	e0:SetOperation(s.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.imcon)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--battle
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetCondition(s.imcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetCondition(s.imcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--change level
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_LEVEL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCondition(s.imcon)
	e7:SetValue(1)
	e7:SetTarget(s.lvtg)
	c:RegisterEffect(e7)
	--cannot release2
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCondition(s.imcon)
	e8:SetTarget(s.intg)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e9)

	if not s.global_flag then
		s.global_flag=true
		s[0]=false
		s[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x5240) and tc:IsType(TYPE_SYNCHRO) then
			if Duel.GetFlagEffect(tc:GetSummonPlayer(),id)~=0 then
				for _,i in ipairs{Duel.GetFlagEffectLabel(tc:GetSummonPlayer(),id)} do
					if i==tc:GetCode() then return end
				end
			end
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,0,0,0,tc:GetCode())
		end
	end
	for p=0,1 do 
		local set={Duel.GetFlagEffectLabel(p,id)}
		if not s[p] and Duel.GetFlagEffect(p,id)~=0 and (#set)>=6 then
			s[p]=true
			--适用全部效果
			local e10=Effect.CreateEffect(e:GetHandler())
			e10:SetDescription(aux.Stringid(id,3))
			e10:SetType(EFFECT_TYPE_FIELD)
			e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_CANNOT_DISABLE)
			e10:SetCode(1200201)
			e10:SetTargetRange(1,0)
			Duel.RegisterEffect(e10,p)
   			Duel.Hint(24,p,aux.Stringid(id,3))
		end
	end
end

function s.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end
function s.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsSetCard(0x5240) and c:IsLinkType(TYPE_SYNCHRO) 
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) 
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function s.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,s.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() or s.supercon(tp) end
	if c:IsAbleToRemoveAsCost() and (not s.supercon(tp) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		Duel.Remove(c,POS_FACEUP,REASON_COST)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCode(1200160) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.imcon(e)
	return e:GetHandler():GetSequence()>4 and s.supercon(e:GetHandlerPlayer())
end
function s.studycon(c,tp)
	return c:GetSequence()>4 and s.supercon(tp)
end
function s.supercon(tp)
	local set={Duel.GetFlagEffectLabel(tp,id)}
	return Duel.GetFlagEffect(tp,id)~=0 and (#set)>=6
end

function s.efilter(e,te)
	if not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end

function s.lvtg(e,c)
	return c:IsSetCard(0x5240) and c:GetLevel()>=2 and c:IsType(TYPE_SYNCHRO)
end

function s.intg(e,c)
	return c:IsSetCard(0x5240) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end