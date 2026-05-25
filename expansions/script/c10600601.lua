--
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.spsfilter,s.xyzcheck,2,2)

	--①效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.spsfilter(c,xyzc)
	return c:IsXyzType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeXyzMaterial(nil)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end

--卡组送墓特召
function s.synchlevelcheck(c,sum,e,tp)
	return c:IsLevel(sum) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.decklevelcheck(c,lv1,exg,e,tp)
	local sum=lv1+c:GetOriginalLevel()
	return exg:IsExists(s.synchlevelcheck,1,nil,sum,e,tp)
end
function s.deckmonget(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if #mg==0 then return false end
	if Duel.GetMZoneCount(tp)==0 then return false end
	local dexg=Duel.GetMatchingGroup(s.deckmonget,tp,LOCATION_DECK,0,nil)
	local exg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
	if #dexg==0 or #exg==0 then return false end
	local falgg = 0
	for tc in aux.Next(mg) do  --对于每个超量素材
		local lv1=tc:GetOriginalLevel()
		if dexg:IsExists(s.decklevelcheck,1,nil,lv1,exg,e,tp) then  --检查卡组里面是否存在等级满足等式的怪兽
			falgg = 1   --有一组满足则为true
		end
	end
	if falgg == 1 then
		return true
	else
		return false
	end
end

function s.mfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	local dexg=Duel.GetMatchingGroup(s.deckmonget,tp,LOCATION_DECK,0,nil)
	local exg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
	if #dexg==0 or #exg==0 then return false end
	local falgg = 0
	local lv1=c:GetOriginalLevel()
	if dexg:IsExists(s.decklevelcheck,1,nil,lv1,exg,e,tp) then
		falgg = 1
	end
	if falgg == 1 then
		return true
	else
		return false
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sp=c:GetControler()
	local g=c:GetOverlayGroup()
	if chk==0 then
		return #g>0 and g:IsExists(s.mfilter,1,nil,e,sp)
	end
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_REMOVEXYZ)
	local sg = g:FilterSelect(sp,s.mfilter,1,1,nil,e,sp)
	if #sg>0 then
		sssg = sg:GetFirst()
		local lv1=sssg:GetOriginalLevel()
		Duel.SendtoGrave(sg,REASON_COST)
		e:SetLabel(lv1)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.levelcheck(c,num)
	return c:IsLevel(num)
end
function s.deckfilter(c,sp,lv1)
	local exg=Duel.GetMatchingGroup(Card.IsType,sp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
	if #exg==0 then return false end
	if not c:IsType(TYPE_MONSTER) then
		return false
	end
	local falggg = 0
	local lv2 = c:GetOriginalLevel()
	local summ = lv1 + lv2
	if exg:IsExists(s.levelcheck,1,nil,summ) then
		falggg = 1
	end
	if falggg == 1 and c:IsAbleToGrave() then
		return true
	else
		return false
	end
end
function s.sylevelcheck(c,num,e,sp)
	return c:IsLevel(num) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sp=c:GetControler()
	local lv1=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.deckfilter,sp,LOCATION_DECK,0,nil,sp,lv1)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_TOGRAVE)
	sg = g:Select(sp, 1, 1, nil)
	sgg = sg:GetFirst()
	local lv2 = sgg:GetOriginalLevel()
	if Duel.Remove(sgg,POS_FACEUP,REASON_EFFECT) and Duel.GetMZoneCount(sp)>0 then
		local numm = lv1+lv2
		local exg=Duel.GetMatchingGroup(s.sylevelcheck,sp,LOCATION_EXTRA,0,nil,numm,e,sp)
		if #exg>0 then
			Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_SPSUMMON)
			local sggg=exg:Select(sp,1,1,nil)
			local tc=sggg:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,sp,sp,false,false,POS_FACEUP) then
				local att=tc:GetAttribute()
        local race=tc:GetRace()
        Duel.SpecialSummonComplete()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.splimit(att,race))
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.splimit(att,race)
    return function(e,c,tp,sumtype,sump,ct)
        return not (c:IsRace(race) and c:IsAttribute(att))
    end
end