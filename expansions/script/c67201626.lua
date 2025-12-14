--复转之狩月人
function c67201626.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x367f),1)
	c:EnableReviveLimit()
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201626,0))
	--e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67201626)
	e1:SetCondition(c67201626.setcon)
	e1:SetTarget(c67201626.settg)
	e1:SetOperation(c67201626.setop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c67201626.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--xyzlv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c67201626.xyzlv)
	e3:SetLabel(3)
	c:RegisterEffect(e3)  
end
function c67201626.xyzlv(e,c,rc)
	if rc:IsSetCard(0x367f) then
		return c:GetLevel()+0x10000*e:GetLabel()
	else
		return c:GetLevel()
	end
end
--
function c67201626.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,67201626) then
		e:GetLabelObject():SetLabel(1)
	end
	if g:IsExists(Card.IsLinkCode,2,nil,67201626) then
		e:GetLabelObject():SetLabel(2)
	end
end
function c67201626.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function c67201626.filter11(c)
	return c:IsSetCard(0x367f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c67201626.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201626.filter11,tp,LOCATION_DECK,0,1,nil) end
end
function c67201626.setop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>=2 and label==2 then ft=2 end
	if ft>=2 and label==1 then ft=1 end
	if ft==1 and label>=1 then ft=1 end
	local g=Duel.GetMatchingGroup(c67201626.filter11,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg)
		end
	end
end