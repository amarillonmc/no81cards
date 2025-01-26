--浮华若梦·绮梦绮月
function c65860055.initial_effect(c)
	c:SetSPSummonOnce(65860055)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65860055.LinkCondition(c65860055.effectmonster,2,c:GetLink(),nil))
	e0:SetTarget(c65860055.LinkTarget(c65860055.effectmonster,2,c:GetLink(),nil))
	e0:SetOperation(c65860055.LinkOperation(c65860055.effectmonster,2,c:GetLink(),nil))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65860055,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65860055)
	e2:SetCost(c65860055.spcost)
	e2:SetTarget(c65860055.sptg)
	e2:SetOperation(c65860055.spop)
	c:RegisterEffect(e2)
end

function c65860055.effectmonster(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_DECK+LOCATION_HAND)) and c:IsCanBeLinkMaterial(nil) and c:IsLinkSetCard(0xa36)
end
function c65860055.LinkCondition(f,minct,maxct,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					local mg2=Duel.GetMatchingGroup(c65860055.effectmonster,tp,LOCATION_DECK+LOCATION_HAND,0,c)
					if mg2:GetCount()>0 then
					mg:Merge(mg2)				  
					end
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				return mg:CheckSubGroup(c65860055.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function c65860055.location(c)
	return not c:IsLocation(LOCATION_EXTRA)
end
function c65860055.lcfilter(c)
	return not c:IsLinkSetCard(0xa36)
end
function c65860055.LCheckGoal(sg,tp,lc,gf,lmat)
	local ug=sg:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg,lc,tp))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat)) and ug:GetCount()<=1
end
function c65860055.LinkTarget(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minct
				local maxc=maxct
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
					local mg2=Duel.GetMatchingGroup(c65860055.effectmonster,tp,LOCATION_DECK+LOCATION_HAND,0,c)
					if mg2:GetCount()>0 then
					mg:Merge(mg2)				  
					end
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,c65860055.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c65860055.LinkOperation(f,minct,maxct,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end

function c65860055.filter1(c)
	return c:IsSetCard(0xa36) and c:IsAbleToHandAsCost() and aux.NecroValleyFilter()
end
function c65860055.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65860055.filter1,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(e:GetHandlerPlayer(),c65860055.filter1,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_COST)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65860055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,2000)
end
function c65860055.sumfilter(c)
	return c:IsAbleToHand()
end
function c65860055.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,2000,REASON_EFFECT) and Duel.IsExistingMatchingCard(c65860055.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.SelectMatchingCard(tp,c65860055.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end
end