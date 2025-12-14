--幻叙指引
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end 
	local codes={}
	while #codes<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=0 
		getmetatable(c).announce_filter={0x838,OPCODE_ISSETCARD,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))		
		table.insert(codes,ac)
		if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			break
		end
	end
	e:SetLabel(table.unpack(codes))
	Duel.SetTargetParam(#codes)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local labs={e:GetLabel()}
	local count=#labs   
	if count and count>0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(count,table.unpack(labs))
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,count)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local labs={e:GetLabel()}
	local ct=labs[1]
	local codes={}
	for i=2,#labs do
		table.insert(codes,labs[i])
	end
	ct=ct-1
	e:SetLabel(ct,table.unpack(labs))
	e:GetHandler():SetTurnCounter(ct)
	if ct==0 then
		Duel.Hint(HINT_CARD,0,id)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
		if ft>0 then
			for _,code in ipairs(codes) do
				if ft<=0 then break end
				local tc=Duel.GetFirstMatchingCard(function(c) return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end, tp, LOCATION_DECK,0,nil)
				if tc then
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					ft=ft-1
				end
			end
			Duel.SpecialSummonComplete()
		end
		local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local eg=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp, LOCATION_EXTRA,0,nil,nil,mg)
		if #eg>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=eg:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.LinkSummon(tp,sg:GetFirst(),nil,mg)
			end
		end
		e:Reset()
	end
end
