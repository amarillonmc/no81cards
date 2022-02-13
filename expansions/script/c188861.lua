local m=188861
local cm=_G["c"..m]
cm.name="方舟骑士-傀影"
cm.named_with_Arknight=1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetOperation(cm.ntop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ep~=tp end)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	c:RegisterEffect(e4)
end
function cm.scfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and _G["c"..c:GetCode()].named_with_Arknight))
end 
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(5) and minc==0 and Duel.IsExistingMatchingCard(Card.IsFacedown,c:GetControler(),LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_HAND,0,1,99,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	if g:IsExists(cm.scfilter,1,nil) then e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0xff0000,0,0) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(function(c)return cm.scfilter(c) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()end,tp,LOCATION_DECK,0,nil)
	if e:GetHandler():GetFlagEffect(m)==0 or #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function cm.sumfilter(c)
	return cm.scfilter(c) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and cm.scfilter(c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetOriginalCode())
end
function cm.filter2(c,e,tp,mc,code)
	return aux.IsCodeListed(c,code) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1)) else op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
		if not tc then return end
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then Duel.Summon(tp,tc,true,nil) else
			Duel.ConfirmCards(1-tp,tc)
			Duel.MSet(tp,tc,true,nil)
		end
	else
		local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE,0,nil,e,tp)
		if g1:GetCount()==0 then return end
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if not tc or tc:IsImmuneToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetOriginalCode()):GetFirst()
		if tc:GetOverlayGroup():GetCount()~=0 then Duel.Overlay(sc,tc:GetOverlayGroup()) end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
