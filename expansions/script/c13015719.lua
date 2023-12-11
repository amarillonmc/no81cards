--深海姬·汇流海马
function c13015719.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,13015719)  
	--e1:SetCost(c13015719.thcost)
	e1:SetTarget(c13015719.thtg)
	e1:SetOperation(c13015719.thop) 
	c:RegisterEffect(e1) 
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c13015719.LinkCondition(nil,2,2,c13015719.lcheck))
	e0:SetTarget(c13015719.LinkTarget(nil,2,2,c13015719.lcheck))
	e0:SetOperation(c13015719.LinkOperation(nil,2,2,c13015719.lcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetValue(c13015719.matval)
	e4:SetTarget(c13015719.mattg)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13015719,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c13015719.lkcon)
	e2:SetTarget(c13015719.lktg)
	e2:SetOperation(c13015719.lkop)
	c:RegisterEffect(e2)
end
function c13015719.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function c13015719.mattg(e,c)
	return not c:IsSetCard(0xe01)
end
function c13015719.lcheckfilter(c)
	return c:IsSetCard(0xe01)
end
function c13015719.lcheck(g)
	return g:IsExists(c13015719.lcheckfilter,1,nil)
end
function c13015719.matf(c,lc)
	return not c:IsSetCard(0xe01)
end
function c13015719.LinkCondition(f,minc,maxc,gf)
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
				local mg=nil
				if og then
					mg=og:Filter(aux.LConditionFilter,nil,f,c,e)
				else
					mg=aux.GetLinkMaterials(tp,f,c,e)
				end
				if Duel.IsExistingMatchingCard(c13015719.matf,tp,LOCATION_SZONE,0,1,nil) then
					local m1=Duel.GetMatchingGroup(c13015719.matf,tp,LOCATION_SZONE,0,c,c)
					mg:Merge(m1)
				end
				if lmat~=nil then
					if not aux.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(aux.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function c13015719.LinkTarget(f,minc,maxc,gf)
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
					mg=og:Filter(aux.LConditionFilter,nil,f,c,e)
				else
					mg=aux.GetLinkMaterials(tp,f,c,e)
				end
				if Duel.IsExistingMatchingCard(c13015719.matf,tp,LOCATION_SZONE,0,1,nil) then
					local m1=Duel.GetMatchingGroup(c13015719.matf,tp,LOCATION_SZONE,0,c,c)
					mg:Merge(m1)
				end
				if lmat~=nil then
					if not aux.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,aux.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c13015719.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				aux.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function c13015719.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xe01) and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xe01) and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c13015719.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end 
function c13015719.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil)  
		local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,nil) 
		if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 and g:GetCount()>0 then 
			Duel.BreakEffect()   
			local sg=g:Select(tp,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)   
		end  
	end 
end 
function c13015719.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c13015719.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(13015719)==0 and Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end 
	c:RegisterFlagEffect(13015719,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13015719.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
