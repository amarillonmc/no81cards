--初嫁的龙姬 古蕾娅
function c11513042.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c11513042.mfilter,2,99,c11513042.lcheck)
	c:EnableReviveLimit()
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c11513042.lmlimit)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11513042) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(c11513042.sptg) 
	e1:SetOperation(c11513042.spop) 
	c:RegisterEffect(e1)	
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11513042,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11513042) 
	e2:SetCondition(c11513042.rcon)
	e2:SetOperation(c11513042.rop)
	c:RegisterEffect(e2)
end
function c11513042.mfilter(c) 
	return not c:IsLinkType(TYPE_TOKEN) and c:IsLevelAbove(1)  
end 
function c11513042.lcheck(g)
	return g:GetClassCount(Card.GetLevel)==1 
end 
function c11513042.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c11513042.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)   
end 
function c11513042.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513042.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c11513042.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513042.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)  
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
		Duel.SpecialSummonComplete() 
		if c:IsRelateToEffect(e) and c:IsFaceup() then 
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		--e1:SetCode(EFFECT_CHANGE_CODE)
		--e1:SetRange(LOCATION_MZONE)
		--e1:SetValue(tc:GetOriginalCodeRule())
		--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		--c:RegisterEffect(e1) 
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		--e1:SetCode(EFFECT_CHANGE_RACE)
		--e1:SetRange(LOCATION_MZONE)
		--e1:SetValue(tc:GetRace())
		--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		--c:RegisterEffect(e1) 
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		--e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		--e1:SetRange(LOCATION_MZONE)
		--e1:SetValue(tc:GetAttribute())
		--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		--c:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE) 
		e2:SetCode(EFFECT_XYZ_LEVEL) 
		e2:SetRange(LOCATION_MZONE) 
		e2:SetLabel(tc:GetLevel())
		e2:SetValue(c11513042.xyzlv) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2) 
			--if Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513042,0)) then  
				--Duel.BreakEffect()
				--local sc=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst() 
				--Duel.XyzSummon(tp,sc,nil) 
			--end 
		end 
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11513042.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
--  Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c11513042.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
--  Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
--  Duel.RegisterEffect(e2,tp)
end
function c11513042.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c11513042.splimit(e,c)
	return not (c:IsType(TYPE_LINK) or (c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48))) and c:IsLocation(LOCATION_EXTRA)
end
function c11513042.xyzlv(e,c,rc) 
	return c:GetLevel()+0x10000*e:GetLabel()  
end
function c11513042.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and re:GetHandler():GetOverlayCount()>=ev-1
end
function c11513042.rop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 then 
	return 1   
	else return 0 end 
end








