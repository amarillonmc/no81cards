-- 方舟骑士团-凯尔希·思衡托
local s,id=GetID()
function s.initial_effect(c)
	-- Xyz summon
	aux.AddXyzProcedure(c,s.check,6,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.check(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function s.filter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0 and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,c,tp)
	local mg=c:GetOverlayGroup()
	if mg then
		mg=mg:Filter(s.filter,nil,tp)
		if mg:GetCount()>0 then
			g:Merge(mg)
		end
	end
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND + LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,c,c,tp)
	local mg=c:GetOverlayGroup()
	if mg then
		mg=mg:Filter(s.filter,nil,tp)
		if mg:GetCount()>0 then
			g:Merge(mg)
		end
	end
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=g:Select(tp,1,1,nil):GetFirst()
	if Duel.SendtoHand(tg,nil,REASON_EFFECT) and tg:IsLocation(LOCATION_HAND + LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		local pseq=c:GetSequence()
		Duel.MoveSequence(c,seq)
		if c:GetSequence()==seq then
		  local zone=0
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
			if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,REASON_SPSUMMON,zone)>0 and tg:IsCanBeSpecialSummoned(e,0,tp,true,false,zone) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				if Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP,zone)>0 then
					local spe=tg.speffect
					if not spe then return end
						if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
						local spetg=spe:GetTarget()
						local speop=spe:GetOperation()
						if spetg and not spetg(e,tp,eg,ep,ev,re,r,rp,0) then return end
						if spetg then
							spetg(e,tp,eg,ep,ev,re,r,rp,1)
						end
						speop(e,tp,eg,ep,ev,re,r,rp)
						end
				end
			end
		end
	end
end