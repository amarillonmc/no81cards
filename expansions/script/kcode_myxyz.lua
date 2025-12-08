NightmareXyzSummon = {}
NightmareXyzSummon.nightmare_setcode = 0x996c
function NightmareXyzSummon.AddXyzProcedure(c, id, min_material)
	if not min_material then min_material = 1 end
	
	aux.AddXyzProcedure(c, nil, 2, 3)
	
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(NightmareXyzSummon.xyzcon(min_material))
	e0:SetOperation(NightmareXyzSummon.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetLabel(min_material)
	c:RegisterEffect(e0)
end

function NightmareXyzSummon.xyzcon(min_material)
	return function(e,c,og,min,max)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(NightmareXyzSummon.xyzfilter,tp,LOCATION_SZONE,0,min_material,nil)
	end
end

function NightmareXyzSummon.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(NightmareXyzSummon.nightmare_setcode) and c:GetSequence()<5
end

function NightmareXyzSummon.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local min = e:GetLabel()
	local con = e:GetCondition()
	if con and type(con) == "function" then
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,NightmareXyzSummon.xyzfilter,tp,LOCATION_SZONE,0,min,min,nil)
	if #g>0 then
		local mg=Group.CreateGroup()
		for tc in aux.Next(g) do
			mg:AddCard(tc)
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
	end
end

function NightmareXyzSummon.GetSetcode()
	return NightmareXyzSummon.nightmare_setcode
end

function NightmareXyzSummon.IsNightmareEquip(c)
	return c:IsSetCard(NightmareXyzSummon.nightmare_setcode) and c:GetType()==TYPE_EQUIP
end

function NightmareXyzSummon.HasNightmareEquip(c)
	return c:GetEquipGroup():IsExists(NightmareXyzSummon.IsNightmareEquip,1,nil)
end

function NightmareXyzSummon.GetNightmareEquipCount(c)
	local eqg=c:GetEquipGroup()
	return eqg:FilterCount(NightmareXyzSummon.IsNightmareEquip,nil)
end


myxyz = NightmareXyzSummon
my = NightmareXyzSummon.nightmare_setcode