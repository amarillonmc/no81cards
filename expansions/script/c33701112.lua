--VTuber Merry Milk
function c33701112.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,nil,c33701112.xyzcheck,3,3)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0x2f)
	c:RegisterEffect(e2)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701112,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(c)
	e2:SetCondition(c33701112.xyzcon)
	e2:SetOperation(c33701112.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c33701112.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)		
	--em
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701112,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33701112.xyzcon2)
	e2:SetOperation(c33701112.xyzop2)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)  
end
function c33701112.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c33701112.mattg(e,c)
	return c:IsSetCard(0x1445) and c:IsType(TYPE_XYZ) 
end
function c33701112.xyzcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local xc=e:GetLabelObject()
	return Duel.GetLocationCountFromEx(tp,tp,xc,e:GetHandler())>0 and xc:IsCanBeXyzMaterial(nil)
end
function c33701112.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local xc=e:GetLabelObject()
	local mg=xc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(e:GetHandler(),mg)
	end
	e:GetHandler():SetMaterial(Group.FromCards(xc))
	Duel.Overlay(e:GetHandler(),Group.FromCards(xc))
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c33701112.splimit)
	Duel.RegisterEffect(e3,tp)
end
function c33701112.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c33701112.xxxfil(c,e,tp)
	return c:IsCanBeXyzMaterial(nil) and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0 and c:IsSetCard(0x1445) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c33701112.xyzcon2(e,c,og,lmat,min,max)
	if c==nil then return Duel.IsExistingMatchingCard(c33701112.xxxfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local tp=c:GetControler()
	return true 
end
function c33701112.xyzop2(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,c33701112.xxxfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	tc:RemoveOverlayCard(tp,1,1,REASON_COST+REASON_XYZ)
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(e:GetHandler(),mg)
	end
	e:GetHandler():SetMaterial(Group.FromCards(tc))
	Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
end


