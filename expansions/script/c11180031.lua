--幻殇·辉骑
function c11180031.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3450),10,true)
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA) 
	e0:SetCountLimit(1,11180032+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c11180031.sprcon)
	e0:SetTarget(c11180031.sprtg)
	e0:SetOperation(c11180031.sprop)
	c:RegisterEffect(e0)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c11180031.pctg)
	e1:SetOperation(c11180031.pcop)
	c:RegisterEffect(e1)
	--lv  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11180031.lvtg)
	e1:SetOperation(c11180031.lvop)
	c:RegisterEffect(e1)
end
function c11180031.sprfilter(c)
	return c:IsSetCard(0x3450,0x6450) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end
function c11180031.fselect(g,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,TYPE_FUSION)>0
		and g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
		and g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
		and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA)
end
function c11180031.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c11180031.sprfilter,tp,0x5e,0,nil)
	return rg:CheckSubGroup(c11180031.fselect,4,4,tp)
end
function c11180031.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c11180031.sprfilter,tp,0x5e,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c11180031.fselect,true,4,4,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11180031.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c11180031.pcfilter(c)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c11180031.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c11180031.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c11180031.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11180031.pcfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c11180031.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,8,e:GetHandler():GetLevel())
	e:SetLabel(lv)
end
function c11180031.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end