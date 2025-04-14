--天启录的血月猫
function c21170035.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21170035.linkcon())
	e0:SetTarget(c21170035.linktg())
	e0:SetOperation(Auxiliary.LinkOperation(nil,nil,nil,nil))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170035,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21170035.con)
	e1:SetTarget(c21170035.tg)
	e1:SetOperation(c21170035.op)
	c:RegisterEffect(e1)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,21170035)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c21170035.tg3)
	e3:SetOperation(c21170035.op3)
	c:RegisterEffect(e3)	
end
function c21170035.mat(c)
	return c:IsSetCard(0x6917)
end
function c21170035.mat2(c)
	return c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170035.LConditionFilter(c,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE)) and c:IsCanBeLinkMaterial(lc) and c21170035.mat(c)
end

function c21170035.GetLinkMaterials(tp,lc,e)
	local mg=Duel.GetMatchingGroup(c21170035.LConditionFilter,tp,LOCATION_MZONE,0,nil,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,c21170035.mat,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	local mg3=Duel.GetMatchingGroup(c21170035.mat2,tp,LOCATION_HAND,0,nil)
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c21170035.linkcon()
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=2
				local maxc=2
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(c21170035.LConditionFilter,nil,c,e)
				else
					mg=c21170035.GetLinkMaterials(tp,c,e)
				end
				if lmat~=nil then
					if not c21170035.LConditionFilter(lmat,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,nil,lmat)
			end
end
function c21170035.linktg()
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=2
				local maxc=2
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(c21170035.LConditionFilter,nil,c,e)
				else
					mg=c21170035.GetLinkMaterials(tp,c,e)
				end
				if lmat~=nil then
					if not c21170035LConditionFilter(lmat,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,nil,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function c21170035.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21170035.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,12,1,nil) end
	Duel.Hint(3,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,12,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c21170035.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c21170035.q(c)
	return c:IsSetCard(0x6917) and c:IsAbleToHand() and c:GetType()==TYPE_SPELL
end

function c21170035.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21170035.q,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21170035.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21170035.q,tp,LOCATION_GRAVE,0,nil)
	if #g>0 then
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	end
end