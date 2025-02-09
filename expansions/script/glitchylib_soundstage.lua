--Library for Sound Stage Cards
if TYPE_SOUNDSTAGE then return end

TYPE_SOUNDSTAGE	= 0x2000000000

FLAG_SOUNDSTAGE_CONTRACT = 1082946

EVENT_SOUNDSTAGE_CONTRACT_EXPIRED	= EVENT_CUSTOM+33720357

STRING_SOUNDSTAGE_CONTRACT_EXPIRED	= aux.Stringid(33720357,2)

--Handle card type overwriting
Auxiliary.SoundStage={}

local is_type, get_type, get_orig_type, get_prev_type_field, get_active_type, is_active_type, get_fusion_type, get_synchro_type, get_xyz_type, get_link_type, get_ritual_type = 
	Card.IsType, Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Effect.GetActiveType, Effect.IsActiveType, Card.GetFusionType, Card.GetSynchroType, Card.GetXyzType, Card.GetLinkType, Card.GetRitualType

Card.IsType=function(c,typ)
	if Auxiliary.SoundStage[c] then
		return c:GetType()&typ>0
	end
	return is_type(c,typ)
end
Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end
Effect.GetActiveType=function(e)
	local tpe=get_active_type(e)
	local c = e:GetType()&0x7f0>0 and e:GetHandler() or e:GetOwner()
	if not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_PENDULUM)) and c:IsType(TYPE_SOUNDSTAGE) then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
	end
	return tpe
end
Effect.IsActiveType=function(e,typ)
	return e:GetActiveType()&typ>0
end

Card.GetFusionType=function(c)
	local tpe=get_fusion_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end
Card.GetSynchroType=function(c)
	local tpe=get_synchro_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end
Card.GetXyzType=function(c)
	local tpe=get_xyz_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end
Card.GetLinkType=function(c)
	local tpe=get_link_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end
Card.GetRitualType=function(c)
	local res=get_ritual_type(c)
	if Auxiliary.SoundStage[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_SOUNDSTAGE
		
	end
	return tpe
end

function Auxiliary.AddOrigSoundStageType(c)
	Auxiliary.SoundStage[c]=true
end

--Add Sound Stage procedure
function Auxiliary.AddSoundStageProc(c,e,id,count,bgmid)
	Auxiliary.SoundStage[c]=true
	if id and bgmid then
		local cost=e:GetCost()
		e:SetCost(function(_e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return not cost or cost(_e,tp,eg,ep,ev,re,r,rp,chk) end
			if cost then cost(_e,tp,eg,ep,ev,re,r,rp,chk) end
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(id,bgmid))
		end)
	end
	
	--Cannot be destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Cannot be replaced by activating/Setting Field Spells
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(function(_e,re,tp)
		return re:GetHandler():IsType(TYPE_FIELD|TYPE_SOUNDSTAGE) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FIELD|TYPE_SOUNDSTAGE))
	c:RegisterEffect(e4)
	--Send to GY after contract expiration
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(STRING_SOUNDSTAGE_CONTRACT_EXPIRED)
	e6:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE|PHASE_END)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_FZONE)
	e6:SetOperation(aux.SoundStageSelfToGY(count))
	c:RegisterEffect(e6)
	
	--Modify TCG/OCG cards (see e5)
	if not aux.SoundStageModCheck then
		aux.SoundStageModCheck=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:OPT()
		ge1:SetOperation(aux.SoundStageMod)
		Duel.RegisterEffect(ge1,0)
	end
	
	return e6
end

Auxiliary.SoundStageModCodes={
	[73468603]=173468603;	--Set Rotation
	[47404795]=147404795;	--Abyss Actor - Super Producer
	[87498729]=187498729;	--Fallen of the Tistina
	[30676200]=130676200;	--Hero of the Ashened City
	[86239173]=186239173;	--Horned Saurus
	[30680659]=130680659;	--Water Enchantress of the Temple
	[30453613]=130453613;	--Awakening of Veidos
	[25964547]=125964547;	--Dream Mirror Hypnagogia
	[65305978]=165305978;	--Fire King Sanctuary
	[49568943]=149568943;	--Vaylantz World - Shinra Bansho
	[75952542]=175952542;	--Vaylantz World - Konig Wissen	
}

function Auxiliary.SoundStageMod(e,tp)
	local g=Duel.GetMatchingGroup(function(c) return aux.SoundStageModCodes[c:GetOriginalCode()] end,0,LOCATION_ALL,LOCATION_ALL,nil)
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		local modcode=aux.SoundStageModCodes[code]
		tc:ReplaceEffect(modcode,0,0)
	end
end

function Card.IsCanPlaceInFieldZone(c,placing_player,receiving_player)
	receiving_player = receiving_player or placing_player
	local fc=Duel.GetFieldGroup(receiving_player,LOCATION_FZONE,0):GetFirst()
	if fc and fc:IsOriginalType(TYPE_SOUNDSTAGE) then
		return false
	end
	return true
end

function Auxiliary.SoundStageSelfToGY(count)
	return	function(e,tp,eg,ep,ev,re,r,rp)   
				local c=e:GetHandler()
				if c:GetFlagEffect(FLAG_SOUNDSTAGE_CONTRACT)==0 then
					c:RegisterFlagEffect(FLAG_SOUNDSTAGE_CONTRACT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,count)
					c:SetTurnCounter(0)
				end
				local ct=c:GetTurnCounter()
				ct=ct+1
				c:SetTurnCounter(ct)
				if ct>=count then
					if Duel.SendtoGrave(c,nil,REASON_RULE)>0 then
						Duel.RaiseSingleEvent(c,EVENT_SOUNDSTAGE_CONTRACT_EXPIRED,e,REASON_RULE,PLAYER_NONE,tp,0)
						Duel.RaiseEvent(Group.FromCards(c),EVENT_SOUNDSTAGE_CONTRACT_EXPIRED,e,REASON_RULE,PLAYER_NONE,tp,0)
					end
				end
			end
end

