--纸影指引
local s,id=GetID()
function s.initial_effect(c)
	--①：从卡组盖放最多2张「纸影剧」陷阱卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end
s.listed_series={0x6328}
function s.setfilter(c)
	return c:IsSetCard(0x6328) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.setfilter2(c,code)
	return s.setfilter(c) and not c:IsCode(code)
end
function s.columncheck(tp,seq)
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then return true end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) then return true end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then return true end
	if seq==1 and (Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)) then return true end
	if seq==3 and (Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)) then return true end
	return false
end
function s.getsetzone(tp)
	local zone=0
	for seq=0,4 do
		if Duel.CheckLocation(tp,LOCATION_SZONE,seq) and s.columncheck(tp,seq) then
			zone=zone|(1<<seq)
		end
	end
	return zone
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.getsetzone(tp)~=0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setcard(e,tp,tc)
	local zone=s.getsetzone(tp)
	if zone==0 then return false end
	local place=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0xffffffff~(zone<<8))
	place=(place>>8)&0x1f
	if place==0 then return false end
	Duel.ConfirmCards(1-tp,tc)
	if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true,place) then return false end
	tc:SetStatus(STATUS_SET_TURN,true)
	Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	return true
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	
	local zone=s.getsetzone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc or not s.setcard(e,tp,tc) then return end
	Duel.ConfirmCards(1-tp,tc)
	local code=tc:GetCode()
	if s.getsetzone(tp)==0 or not Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_DECK,0,1,nil,code) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectMatchingCard(tp,s.setfilter2,tp,LOCATION_DECK,0,1,1,nil,code)
	local tc2=g2:GetFirst()
	if tc2 then
		s.setcard(e,tp,tc2)
		Duel.ConfirmCards(1-tp,tc2)
	end
end