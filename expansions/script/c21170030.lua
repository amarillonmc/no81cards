--天启录的破灭书
function c21170030.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21170030.linkcon())
	e0:SetTarget(c21170030.linktg())
	e0:SetOperation(Auxiliary.LinkOperation(nil,nil,nil,nil))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c21170030.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170030,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21170030)
	e2:SetTarget(c21170030.tg)
	e2:SetOperation(c21170030.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,21170031)
	e3:SetCondition(c21170030.con3)
	e3:SetTarget(c21170030.tg3)
	e3:SetOperation(c21170030.op3)
	c:RegisterEffect(e3)
end
function c21170030.mat(c)
	return c:IsSetCard(0x6917)
end
function c21170030.mat2(c)
	return c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170030.LConditionFilter(c,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE)) and c:IsCanBeLinkMaterial(lc) and c21170030.mat(c)
end

function c21170030.GetLinkMaterials(tp,lc,e)
	local mg=Duel.GetMatchingGroup(c21170030.LConditionFilter,tp,LOCATION_MZONE,0,nil,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,c21170030.mat,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	local mg3=Duel.GetMatchingGroup(c21170030.mat2,tp,LOCATION_HAND,0,nil)
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c21170030.linkcon()
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
					mg=og:Filter(c21170030.LConditionFilter,nil,c,e)
				else
					mg=c21170030.GetLinkMaterials(tp,c,e)
				end
				if lmat~=nil then
					if not c21170030.LConditionFilter(lmat,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,nil,lmat)
			end
end
function c21170030.linktg()
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
					mg=og:Filter(c21170030.LConditionFilter,nil,c,e)
				else
					mg=c21170030.GetLinkMaterials(tp,c,e)
				end
				if lmat~=nil then
					if not c21170030LConditionFilter(lmat,c,e) then return false end
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
function c21170030.disable(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:IsFaceup()
end
function c21170030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,4,4,1,nil) end
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,4,4,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21170030.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsSetCard(0x6917) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(21170030,1)) then
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c21170030.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c21170030.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,4,4,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c21170030.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,4,4,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end