--罪恶的根源
local cm,m=GetID()
--lib
AlterEgo=AlterEgo or {}
ae=AlterEgo
function ae.initial(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ae.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(ae.recon)
	e3:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(ae.repcon)
	e4:SetOperation(ae.repop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,c:GetOriginalCode()+1000)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(ae.sptg)
	e5:SetOperation(ae.spop)
	c:RegisterEffect(e5)
	--ptos
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(ae.ptoscon)
	e6:SetOperation(ae.ptosop)
	c:RegisterEffect(e6)
end
function ae.value(e,c)
	return Duel.GetMatchingGroupCount(ae.filter,c:GetControler(),LOCATION_ONFIELD,0,nil)*1000
end
function ae.filter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo and c:IsFaceup()
end
function ae.cfilter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo
end
function ae.recon(e)
	return e:GetHandler():IsLocation(LOCATION_SZONE) and not e:GetHandler():IsLocation(LOCATION_PZONE)
end
function ae.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function ae.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetPreviousControler()
	local num=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then num=num+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then num=num+1 end
	if (num==0 or not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetOwner())) then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function ae.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function ae.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ae.ptoscon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function ae.ptosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(130006111,1))
	end
end
--
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--aux.AddLinkProcedure(c,ae.cfilter,1,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	local max=c:GetLink()
	e0:SetCondition(cm.LinkCondition(ae.cfilter,1,max))
	e0:SetTarget(cm.LinkTarget(ae.cfilter,1,max))
	e0:SetOperation(Auxiliary.LinkOperation(ae.cfilter,1,max))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--cannot be link material
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--chainlm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.chainop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(ae.filter))
	e4:SetValue(cm.efilter2)
	c:RegisterEffect(e4)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.labop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.discon)
	e6:SetTarget(cm.distg)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	e5:SetLabelObject(e6)
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	local ct=Duel.GetMatchingGroupCount(ae.filter,tp,LOCATION_ONFIELD,0,nil)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink()-ct,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function cm.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local ct=Duel.GetMatchingGroupCount(ae.filter,tp,LOCATION_ONFIELD,0,nil)
				--Debug.Message(c:GetLink()-ct)
				if ct>=c:GetLink() then return false end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.efilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ae.cfilter(re:GetHandler()) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.thfilter(c)
	return ae.cfilter(c) and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.labop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(ae.filter,tp,LOCATION_ONFIELD,0,nil)
	e:GetLabelObject():SetLabel(ct)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()>0 end
	e:SetLabel(e:GetLabel()-1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end