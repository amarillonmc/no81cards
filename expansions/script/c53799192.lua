local m=53799192
local cm=_G["c"..m]
cm.name="匿形者 JGN"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,2,cm.ovfilter,aux.Stringid(m,0),99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.descon)
	e1:SetCost(cm.descost)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.ovfilter(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsRankBelow(4) and c:IsRace(RACE_WARRIOR) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and loc&LOCATION_MZONE~=0 and aux.GetColumn(e:GetHandler(),tp)==4-aux.MZoneSequence(seq)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=c:GetSequence()
	Duel.MoveSequence(c,math.log(fd,2))
	e:SetLabel(aux.MZoneSequence(seq),c:GetSequence())
end
function cm.seqfilter(c,seq1,seq2)
	local seq=4-aux.MZoneSequence(c:GetSequence())
	if seq1==seq2 then return seq==seq2
	elseif seq1>seq2 then return seq>seq2 and seq<=seq1 
	else return seq>=seq1 and seq<seq2 end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e1:SetLabel(re)
		e1:SetValue(function(e,re)return re==e:GetLabelObject()end)
		c:RegisterEffect(e1)
		local seq,pseq=e:GetLabel()
		if pseq~=c:GetSequence() then return end
		local g=Duel.GetMatchingGroup(cm.seqfilter,tp,0,LOCATION_MZONE,nil,seq,pseq)
		if pseq==c:GetSequence() and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
