--飓风之观测者 万由里
local m=33401603
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
XY.mayuri(c)
	--set
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m+10000)
	e7:SetCondition(cm.stcon)
	e7:SetOperation(cm.stop)
	c:RegisterEffect(e7)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and re:GetHandler()~=e:GetHandler()
end
function cm.ckfilter1(c,tp)  
	return   c:IsAbleToHand() and  (c:IsType(TYPE_SPELL+TYPE_TRAP) or (c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.cckfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())))
end
function cm.cckfilter(c,at)
	return   c:IsFaceup() and c:GetAttribute()&at~=0
end
function cm.thfilter1(c)
	return  c:IsSetCard(0x6344)  and c:IsAbleToHand()
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local seq1=aux.MZoneSequence(c:GetSequence())
	local seq2=seq
	if re:IsActiveType(TYPE_MONSTER) then seq=aux.MZoneSequence(seq) end
	if ((seq1==4-seq and rp==1-tp) or (seq1==seq and rp==tp)) or (rp==tp and math.abs(c:GetSequence()-seq)<=1 and loc==LOCATION_MZONE and seq2<5) then 
		local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Filter(cm.ckfilter1,nil,tp)			 
		if cg:GetCount()>0 and  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=cg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	else
		if  Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE,0,1,nil)and Duel.SelectYesNo(tp,aux.Stringid(m,2))  then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end