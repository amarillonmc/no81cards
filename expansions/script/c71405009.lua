--棱镜世界的故障-分离
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),1,2,nil,nil,99)
	--banish and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg1)
	e1:SetCost(s.cost1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--currently e1 cannot be implemented
	--remove and special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+100000)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	--special summon material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	local e0a=e0:Clone()
	e0a:SetLabelObject(e3)
	c:RegisterEffect(e0a)
end
function s.filter1(c)
	return c:IsSetCard(0x716) and c:IsFaceup() and c:IsAbleToRemove()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==1 or
		c:GetOverlayGroup():IsExists(Card.IsAbleToRemoveAsCost,1,nil) and c:GetOverlayCount()>0
	end
	if e:GetLabel()~=1 then
		local g=c:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,POS_FACEUP)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return
		Duel.IsPlayerCanDraw(tp,1) and g:GetCount()>1
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,nil,LOCATION_ONFIELD)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabel()==1 or
		c:GetOverlayGroup():IsExists(Card.IsAbleToRemoveAsCost,3,nil) and c:GetOverlayCount()>2
	end
	if e:GetLabel()~=1 then
		local g=c:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:FilterSelect(tp,Card.IsAbleToRemove,3,3,nil,POS_FACEUP)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function s.filter3(c,e,tp)
	return c:IsSetCard(0x716) and c:IsType(TYPE_XYZ) and not c:IsCode(id)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
		Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0
		or not (c:IsLocation(LOCATION_REMOVED) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL))
		or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)==0
		then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(nil)
		if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			sc:CompleteProcedure()
		end
		Duel.SpecialSummonComplete()
	end
end
function s.valcheck(e,c)
	if c:GetMaterial():GetCount()==0 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end