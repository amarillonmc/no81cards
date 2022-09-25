--银刺龙女帝 露姬雅－逆
local m=40009487
local cm=_G["c"..m]
cm.named_with_SilverThorn=1
cm.named_with_Reverse=1
function cm.SilverThorn(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SilverThorn
end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.atkcost)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)  
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.atkcon)
	e2:SetCost(cm.atkcost)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)   
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() 
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	--local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,1,1)
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g1,POS_FACEDOWN_ATTACK)
			local tc=g1:GetFirst()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetCondition(cm.flipcon)
		e1:SetOperation(cm.flipop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		--e2:SetCondition(cm.rcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e3,tp)
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>3 then ft=3 end
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--g:GetClassCount(Card.GetLevel)>=3
	--g=g:Select(tp,1,ft,nil)
	local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,1,ft)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsType(TYPE_XYZ)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.toexfilter(c,tp)
	return c:IsCode(40009487,40009488) and c:IsAbleToExtra() and c:GetOwner()==tp
end
function cm.grfilter(c)
	return c:IsCode(40009487,40009488)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=c:GetOverlayGroup()
	if ft>3 then ft=3 end
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	--g=g:Select(tp,1,ft,nil)
	local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,1,ft)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
	if (not c:GetOriginalCode(40009487)) and c:GetOverlayGroup():IsExists(cm.grfilter,1,nil) and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sc=sg:FilterSelect(tp,cm.toexfilter,1,1,nil,tp):GetFirst()
		if sc and Duel.SendtoDeck(sc,nil,0,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsControler(tp) and not c:IsImmuneToEffect(e) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsCanBeXyzMaterial(sc) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 then
			Duel.BreakEffect()
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end