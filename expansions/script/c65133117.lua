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
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsSetCard(0x838) and c:IsDiscardable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_DISCARD+REASON_COST,nil)
end
function s.filter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local afilter={
		TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,
		0x838,OPCODE_ISSETCARD,OPCODE_AND,
		TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND
	}
	getmetatable(e:GetHandler()).announce_filter=afilter
	local codes={}
	while #codes<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		table.insert(codes,ac)
		for i=1,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_NOT)
			table.insert(afilter,OPCODE_AND)
		end
		if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			break
		end
	end
	e:SetLabel(table.unpack(codes))
	Duel.SetTargetParam(#codes)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local labs={e:GetLabel()}
	local count=#labs   
	if count and count>0 then	   
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(count,table.unpack(labs))
		e1:SetLabelObject(c)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,count)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	--local c=e:GetLabelObject()
	local labs={e:GetLabel()}
	local ct=labs[1]
	local codes={}
	for i=2,#labs do
		table.insert(codes,labs[i])
	end
	ct=ct-1
	e:SetLabel(ct,table.unpack(labs))
	--c:SetTurnCounter(ct)
	if ct==0 then
		Duel.Hint(HINT_CARD,0,id)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
		if ft>0 then
			for _,code in ipairs(codes) do
				if ft<=0 then break end
				local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,code)
				local tc=g:GetFirst()
				if g:GetCount()>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
				if tc then
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					ft=ft-1
				end
			end
			Duel.SpecialSummonComplete()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
		e:Reset()
	end
end
