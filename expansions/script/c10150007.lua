--次元再诱爆
function c10150007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,10150007+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10150007.target)
	e1:SetOperation(c10150007.activate)
	c:RegisterEffect(e1)	
end
function c10150007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct,ctbl=c10150007.checktype(tp)
	if chk==0 then return ct>1 and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10150007.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct,ctbl=c10150007.checktype(tp)
	if ct>=2 then
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
	--if ct>=3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(10150007,0)) then
	   --Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   --local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	   --Duel.HintSelection(dg)
	   --Duel.Destroy(dg,REASON_EFFECT)
	--end
	if ct>=3 and Duel.IsExistingMatchingCard(c10150007.spfilter,tp,LOCATION_EXTRA,0,1,nil,ctbl,e,tp) and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(10150007,1)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=Duel.SelectMatchingCard(tp,c10150007.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,ctbl,e,tp)
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	--if ct>=5 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1 and Duel.SelectYesNo(tp,aux.Stringid(10150007,2)) then
	   --local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
	   --Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	--end
end
function c10150007.spfilter(c,ctbl,e,tp)
	for k,v in ipairs(ctbl) do
		if bit.band(v,c:GetType())~=0 then return end
	end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10150007.checktype(tp)
	local tbl={ TYPE_XYZ,TYPE_SYNCHRO,TYPE_LINK,TYPE_PENDULUM,TYPE_FUSION }
	local ctbl={}
	local ct=0
	for i=1,5 do
		if Duel.IsExistingMatchingCard(c10150007.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tbl[i]) then
		   ct=ct+1
		   ctbl[ct]=tbl[i]
		end
	end
	return ct,ctbl
end
function c10150007.cfilter(c,ctype)
	return c:IsFaceup() and c:IsType(ctype) 
end
