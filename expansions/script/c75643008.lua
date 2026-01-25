--恩赐印章 士兵
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75643010)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.con)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.mtfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x52c6) and c:IsCanOverlay()
end
function s.gcheck(g,e,tp)
	if #g~=2 then return false end
	local a=g:GetFirst()
	local d=g:GetNext()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,a:GetCode(),d:GetCode())
end
function s.spfilter(c,e,tp,code1,code2)
	return c:IsSetCard(0x52c6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code1,code2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetClassCount(Card.GetCode)>1 and g:CheckSubGroup(s.gcheck,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.ovfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=tg:GetFirst()
	local d=tg:GetNext()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,tg,e,tp,a:GetCode(),d:GetCode()):GetFirst()
	if sc then
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
			local g=tg:Filter(s.ovfilter,sc,e)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				while tc do
					local og=tc:GetOverlayGroup()
					if og:GetCount()>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(sc,tc)
					tc=g:GetNext()
				end
			end
		end
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(75643000)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_PAY_LPCOST)  
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.costcon)
	e1:SetOperation(s.costop)
	Duel.RegisterEffect(e1,tp)
end
function s.costcon(e,tp,eg,ep,ev,re,r,rp)
	if not (tp==ep and re and re:IsActivated()) then return false end
	local rc=re:GetHandler()
	return rc:IsRelateToEffect(re) and aux.IsCodeListed(rc,75643010)
		or not rc:IsRelateToEffect(re)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end