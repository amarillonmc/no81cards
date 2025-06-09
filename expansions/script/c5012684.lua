--蕾薇妮雅·柏德蔚
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,10,2)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.lvtg)
	e1:SetValue(s.lvval)
	c:RegisterEffect(e1)  
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.XyzCondition(nil,10,2,2))
	e2:SetTarget(Auxiliary.XyzTarget(nil,10,2,2))
	e2:SetOperation(Auxiliary.XyzOperation(nil,10,2,2))
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)   
	--remove
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	e14:SetCondition(s.rmcon)
	e14:SetTarget(s.rmtg)
	e14:SetOperation(s.rmop)
	c:RegisterEffect(e14)
	--
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(id,1))
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetCountLimit(3)
	e21:SetCondition(s.xcon)
	e21:SetTarget(s.xtg)
	e21:SetOperation(s.xop)
	c:RegisterEffect(e21)
	--destroy
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(id,1))
	e24:SetCategory(CATEGORY_REMOVE)
	e24:SetType(EFFECT_TYPE_QUICK_O)
	e24:SetCode(EVENT_CHAINING)
	e24:SetRange(LOCATION_MZONE)
	e24:SetCondition(s.descon)
	e24:SetTarget(s.destg)
	e24:SetOperation(s.desop)
	c:RegisterEffect(e24)
	--cannot release
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_UNRELEASABLE_SUM)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e25=e13:Clone()
	e25:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e25)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--damage
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e41:SetCode(EVENT_LEAVE_FIELD_P)
	e41:SetOperation(s.damp)
	c:RegisterEffect(e41)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_REMOVE)
	e5:SetOperation(s.damop)
	e5:SetLabelObject(e41)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_TO_DECK)
	e6:SetCondition(s.tgcon)
	c:RegisterEffect(e6)
end
function s.lvtg(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(1)
end
function s.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 10
	else return lv end
end
function s.XyzCondition(f,lv,minct,maxct)
	--og: use special material
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if not c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.mtfilter(c,tp,e)
	return not c:IsImmuneToEffect(e) and (c:IsAbleToChangeControler() or c:IsControler(tp))
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,tp,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
end
function s.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp)
		and chkc:IsCanOverlay() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function s.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsCanOverlay() then
		tc:CancelToGrave()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetOverlayCount()>=22
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(Card.IsAbleToRemove,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and #og>0 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	g:Merge(og)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local og=c:GetOverlayGroup():Filter(Card.IsAbleToRemove,nil)
	g:Merge(og)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoExtraP(c,nil,REASON_EFFECT)
end
function s.damp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	og:KeepAlive()
	e:SetLabelObject(og)
end
function s.chkfilter(c,tp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsControler(tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown()
end
function s.tgfilter(c)
	return c.MoJin and c:IsAbleToGrave()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject():GetLabelObject()
	if not og then return end
	local tg=og:Filter(Card.IsAbleToDeck,nil)
	if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local cg=Duel.GetOperatedGroup()
		if cg:IsExists(s.chkfilter,3,nil,tp) then
			local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
			if g:GetClassCount(Card.GetCode)<3 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
			Duel.SendtoGrave(tg1,REASON_EFFECT)
		end
	end
end